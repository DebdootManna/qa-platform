/*
  # Initial Schema Setup

  1. New Tables
    - `profiles`
      - `id` (uuid, primary key)
      - `username` (text, unique)
      - `created_at` (timestamp)
    - `questions`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references profiles)
      - `title` (text)
      - `content` (text)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on both tables
    - Add policies for:
      - Anyone can read profiles and questions
      - Only authenticated users can create questions
      - Users can only update/delete their own questions
*/

-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  username text UNIQUE NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create questions table
CREATE TABLE IF NOT EXISTS questions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id) NOT NULL,
  title text NOT NULL,
  content text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE questions ENABLE ROW LEVEL SECURITY;

-- Create policies for profiles
CREATE POLICY "Anyone can view profiles"
  ON profiles
  FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Users can update their own profile"
  ON profiles
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);

-- Create policies for questions
CREATE POLICY "Anyone can view questions"
  ON questions
  FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Authenticated users can create questions"
  ON questions
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own questions"
  ON questions
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own questions"
  ON questions
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Insert sample data
INSERT INTO profiles (id, username) VALUES
  ('d0fc4c64-a3d6-4d97-9341-07de24439549', 'john_doe'),
  ('e8b7f203-c1d7-4a3c-9b77-1d8c6a9b9b9b', 'jane_smith'),
  ('f9c8b7a6-5d4e-3f2c-1a9b-8c7d6e5f4e3d', 'bob_wilson');

INSERT INTO questions (user_id, title, content) VALUES
  ('d0fc4c64-a3d6-4d97-9341-07de24439549', 'How to use Next.js with Supabase?', 'I am new to Next.js and Supabase. Can someone explain how to integrate them properly?'),
  ('e8b7f203-c1d7-4a3c-9b77-1d8c6a9b9b9b', 'Best practices for React hooks', 'What are some best practices when using React hooks in a production environment?'),
  ('f9c8b7a6-5d4e-3f2c-1a9b-8c7d6e5f4e3d', 'Understanding TypeScript generics', 'Can someone explain TypeScript generics with practical examples?');