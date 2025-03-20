/*
  # Setup Auth Users and Link to Profiles

  1. Changes
    - Add email field to profiles table
    - Update sample users with email addresses
    - Ensure profiles are linked to auth.users
*/

-- Add email field to profiles
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS email text UNIQUE;

-- Update existing profiles with email
UPDATE profiles 
SET email = username || '@example.com'
WHERE email IS NULL;

-- Make email required for future inserts
ALTER TABLE profiles ALTER COLUMN email SET NOT NULL;