/*
  # Fix Demo Users

  1. Changes
    - Remove existing demo users
    - Add new demo users with different UUIDs
    - Ensure consistent data between auth and profiles

  2. Security
    - Users are created with email confirmation
    - Default password is set for demo accounts
*/

-- First, clean up any existing demo users to avoid conflicts
DELETE FROM auth.users WHERE email IN (
  'user1@example.com',
  'user2@example.com',
  'user3@example.com'
);

DELETE FROM public.profiles WHERE email IN (
  'user1@example.com',
  'user2@example.com',
  'user3@example.com'
);

-- Insert demo users into auth.users with new UUIDs
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at)
VALUES 
  ('44444444-4444-4444-4444-444444444444', 'user1@example.com', crypt('password123', gen_salt('bf')), now()),
  ('55555555-5555-5555-5555-555555555555', 'user2@example.com', crypt('password123', gen_salt('bf')), now()),
  ('66666666-6666-6666-6666-666666666666', 'user3@example.com', crypt('password123', gen_salt('bf')), now());

-- Insert corresponding profiles with matching UUIDs
INSERT INTO public.profiles (id, email, username)
VALUES 
  ('44444444-4444-4444-4444-444444444444', 'user1@example.com', 'user1'),
  ('55555555-5555-5555-5555-555555555555', 'user2@example.com', 'user2'),
  ('66666666-6666-6666-6666-666666666666', 'user3@example.com', 'user3');