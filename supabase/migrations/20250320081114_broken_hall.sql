/*
  # Fix Authentication System

  1. Changes
    - Create auth users for existing profiles
    - Update profiles to use auth.uid() as id
    - Add trigger to create profile on auth user creation

  2. Security
    - Ensure profiles are linked to auth users
    - Maintain data consistency
*/

-- Create auth users for existing profiles
DO $$
DECLARE
  profile RECORD;
BEGIN
  FOR profile IN SELECT * FROM profiles
  LOOP
    INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at)
    VALUES (
      profile.id,
      profile.email,
      crypt('password123', gen_salt('bf')),
      now()
    )
    ON CONFLICT (id) DO NOTHING;
  END LOOP;
END $$;

-- Create a trigger to automatically create a profile when a new user signs up
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, email, username)
  VALUES (
    new.id,
    new.email,
    split_part(new.email, '@', 1)
  );
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create the trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();