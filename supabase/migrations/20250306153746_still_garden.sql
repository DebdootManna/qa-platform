/*
  # Initial Schema Setup for Q&A Platform

  1. New Tables
    - `profiles`
      - Stores user profile information
      - Links to Supabase auth.users
    - `questions`
      - Stores questions posted by users
      - Supports anonymous posting
    - `answers`
      - Stores answers to questions
      - Links to questions and users
    - `ratings`
      - Stores answer ratings
      - One rating per user per answer
    - `tags`
      - Stores question tags
    - `question_tags`
      - Junction table for questions and tags

  2. Security
    - Enable RLS on all tables
    - Add policies for:
      - Reading public data
      - Managing own content
      - Anonymous posting
      - Rating answers
*/

-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id),
  username text UNIQUE,
  bio text,
  avatar_url text,
  is_anonymous boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create questions table
CREATE TABLE IF NOT EXISTS questions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  content text NOT NULL,
  author_id uuid REFERENCES profiles(id),
  is_anonymous boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create answers table
CREATE TABLE IF NOT EXISTS answers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  content text NOT NULL,
  question_id uuid REFERENCES questions(id) ON DELETE CASCADE,
  author_id uuid REFERENCES profiles(id),
  is_anonymous boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create ratings table
CREATE TABLE IF NOT EXISTS ratings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  answer_id uuid REFERENCES answers(id) ON DELETE CASCADE,
  user_id uuid REFERENCES profiles(id),
  rating integer CHECK (rating >= 1 AND rating <= 5),
  created_at timestamptz DEFAULT now(),
  UNIQUE(answer_id, user_id)
);

-- Create tags table
CREATE TABLE IF NOT EXISTS tags (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create question_tags junction table
CREATE TABLE IF NOT EXISTS question_tags (
  question_id uuid REFERENCES questions(id) ON DELETE CASCADE,
  tag_id uuid REFERENCES tags(id) ON DELETE CASCADE,
  PRIMARY KEY (question_id, tag_id)
);

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE question_tags ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Public profiles are viewable by everyone"
  ON profiles FOR SELECT
  USING (true);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

-- Questions policies
CREATE POLICY "Questions are viewable by everyone"
  ON questions FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can insert questions"
  ON questions FOR INSERT
  WITH CHECK (auth.uid() = author_id);

CREATE POLICY "Users can update own questions"
  ON questions FOR UPDATE
  USING (auth.uid() = author_id);

-- Answers policies
CREATE POLICY "Answers are viewable by everyone"
  ON answers FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can insert answers"
  ON answers FOR INSERT
  WITH CHECK (auth.uid() = author_id);

CREATE POLICY "Users can update own answers"
  ON answers FOR UPDATE
  USING (auth.uid() = author_id);

-- Ratings policies
CREATE POLICY "Ratings are viewable by everyone"
  ON ratings FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can insert ratings"
  ON ratings FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own ratings"
  ON ratings FOR UPDATE
  USING (auth.uid() = user_id);

-- Tags policies
CREATE POLICY "Tags are viewable by everyone"
  ON tags FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can insert tags"
  ON tags FOR INSERT
  WITH CHECK (auth.role = 'authenticated');

-- Question tags policies
CREATE POLICY "Question tags are viewable by everyone"
  ON question_tags FOR SELECT
  USING (true);

CREATE POLICY "Question authors can manage tags"
  ON question_tags FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM questions
      WHERE questions.id = question_id
      AND questions.author_id = auth.uid()
    )
  );

-- Create functions for aggregating ratings
CREATE OR REPLACE FUNCTION get_answer_rating(answer_uuid uuid)
RETURNS float AS $$
  SELECT COALESCE(AVG(rating)::float, 0)
  FROM ratings
  WHERE answer_id = answer_uuid;
$$ LANGUAGE SQL STABLE;

CREATE OR REPLACE FUNCTION get_user_rating(user_uuid uuid)
RETURNS float AS $$
  SELECT COALESCE(AVG(r.rating)::float, 0)
  FROM answers a
  JOIN ratings r ON r.answer_id = a.id
  WHERE a.author_id = user_uuid;
$$ LANGUAGE SQL STABLE;