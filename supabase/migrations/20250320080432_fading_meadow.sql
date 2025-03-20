/*
  # Add Sample Data

  1. Sample Data
    - Add three sample users to profiles table
    - Add three sample questions linked to users
*/

-- Insert sample data
INSERT INTO profiles (id, username) VALUES
  ('d0fc4c64-a3d6-4d97-9341-07de24439549', 'user1'),
  ('e8b7f203-c1d7-4a3c-9b77-1d8c6a9b9b9b', 'user2'),
  ('f9c8b7a6-5d4e-3f2c-1a9b-8c7d6e5f4e3d', 'user3');

INSERT INTO questions (user_id, title, content) VALUES
  ('d0fc4c64-a3d6-4d97-9341-07de24439549', 'How to use Next.js with Supabase?', 'I am new to Next.js and Supabase. Can someone explain how to integrate them properly?'),
  ('e8b7f203-c1d7-4a3c-9b77-1d8c6a9b9b9b', 'Best practices for React hooks', 'What are some best practices when using React hooks in a production environment?'),
  ('f9c8b7a6-5d4e-3f2c-1a9b-8c7d6e5f4e3d', 'Understanding TypeScript generics', 'Can someone explain TypeScript generics with practical examples?');