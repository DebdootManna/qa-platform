/*
  # Initial Schema Setup for Q&A Platform

  1. New Tables
    - `profiles`
      - Stores user profile information
      - Links to auth.users
    - `questions`
      - Stores questions posted by users
    - `answers`
      - Stores answers to questions
    - `ratings`
      - Stores answer ratings (1-5 stars)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated and public access
*/

-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id),
  username text UNIQUE NOT NULL,
  email text UNIQUE NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create questions table
CREATE TABLE IF NOT EXISTS questions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  content text NOT NULL,
  user_id uuid REFERENCES profiles(id) NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create answers table
CREATE TABLE IF NOT EXISTS answers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  content text NOT NULL,
  question_id uuid REFERENCES questions(id) ON DELETE CASCADE,
  user_id uuid REFERENCES profiles(id) NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create ratings table
CREATE TABLE IF NOT EXISTS ratings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  answer_id uuid REFERENCES answers(id) ON DELETE CASCADE,
  user_id uuid REFERENCES profiles(id) NOT NULL,
  rating integer CHECK (rating >= 1 AND rating <= 5),
  created_at timestamptz DEFAULT now(),
  UNIQUE(answer_id, user_id)
);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE ratings ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Profiles are viewable by everyone"
  ON profiles FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Users can update their own profile"
  ON profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);

-- Questions policies
CREATE POLICY "Questions are viewable by everyone"
  ON questions FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Authenticated users can create questions"
  ON questions FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own questions"
  ON questions FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own questions"
  ON questions FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Answers policies
CREATE POLICY "Answers are viewable by everyone"
  ON answers FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Authenticated users can create answers"
  ON answers FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own answers"
  ON answers FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own answers"
  ON answers FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Ratings policies
CREATE POLICY "Ratings are viewable by everyone"
  ON ratings FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Authenticated users can create ratings"
  ON ratings FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own ratings"
  ON ratings FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

-- Create function to handle new user signups
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

-- Create trigger for new user signups
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Insert demo users
DO $$
BEGIN
  -- Clean up existing demo users
  DELETE FROM auth.users WHERE email IN (
    'user1@example.com',
    'user2@example.com',
    'user3@example.com'
  );

  -- Insert demo users into auth.users
  INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at)
  VALUES 
    ('11111111-1111-1111-1111-111111111111', 'user1@example.com', crypt('password123', gen_salt('bf')), now()),
    ('22222222-2222-2222-2222-222222222222', 'user2@example.com', crypt('password123', gen_salt('bf')), now()),
    ('33333333-3333-3333-3333-333333333333', 'user3@example.com', crypt('password123', gen_salt('bf')), now());

  -- Profiles will be created automatically via trigger
END $$;

-- Insert sample questions
INSERT INTO questions (user_id, title, content) VALUES
  ('11111111-1111-1111-1111-111111111111', 'How to use Next.js with Supabase?', 'I am new to Next.js and Supabase. Can someone explain how to integrate them properly?'),
  ('22222222-2222-2222-2222-222222222222', 'Best practices for React hooks', 'What are some best practices when using React hooks in a production environment?'),
  ('33333333-3333-3333-3333-333333333333', 'Understanding TypeScript generics', 'Can someone explain TypeScript generics with practical examples?');