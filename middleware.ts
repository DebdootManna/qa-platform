import { createMiddlewareClient } from '@supabase/auth-helpers-nextjs';
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export async function middleware(req: NextRequest) {
  try {
    const res = NextResponse.next();
    
    // Only create Supabase client if environment variables are present
    if (process.env.NEXT_PUBLIC_SUPABASE_URL && process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY) {
      const supabase = createMiddlewareClient({ req, res });
      await supabase.auth.getSession();
    }
    
    return res;
  } catch (error) {
    console.error('Middleware error:', error);
    return NextResponse.next();
  }
}