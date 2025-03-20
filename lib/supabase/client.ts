import { createClient } from '@supabase/supabase-js';
import { Database } from './types';

// Default to empty strings if env vars are not set
// This prevents runtime errors, but the client won't work until proper values are set
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || '';
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '';

export const supabase = createClient<Database>(
  supabaseUrl,
  supabaseAnonKey,
  {
    auth: {
      persistSession: true,
      autoRefreshToken: true,
    },
  }
);