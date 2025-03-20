/*
  # Add Demo Users

  1. Changes
    - Add demo users to auth.users and profiles tables
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

-- Insert demo users into auth.users
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at)
VALUES 
  ('11111111-1111-1111-1111-111111111111', 'user1@example.com', crypt('password123', gen_salt('bf')), now()),
  ('22222222-2222-2222-2222-222222222222', 'user2@example.com', crypt('password123', gen_salt('bf')), now()),
  ('33333333-3333-3333-3333-333333333333', 'user3@example.com', crypt('password123', gen_salt('bf')), now());

-- Insert corresponding profiles
INSERT INTO public.profiles (id, email, username)
VALUES 
  ('11111111-1111-1111-1111-111111111111', 'user1@example.com', 'user1'),
  ('22222222-2222-2222-2222-222222222222', 'user2@example.com', 'user2'),
  ('33333333-3333-3333-3333-333333333333', 'user3@example.com', 'user3');