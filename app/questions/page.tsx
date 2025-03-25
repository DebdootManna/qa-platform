'use client';

import { useEffect, useState } from 'react';
import { notFound } from 'next/navigation';
import { formatDistanceToNow } from 'date-fns';
import { supabase } from '@/lib/supabase/client';

interface Question {
  id: string;
  title: string;
  content: string;
  created_at: string;
  profiles: {
    username: string;
  };
}

interface PageProps {
  params: {
    id: string;
  };
  searchParams?: { [key: string]: string | string[] | undefined };
}

export default function QuestionPage({ params }: PageProps) {
  const [question, setQuestion] = useState<Question | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchQuestion = async () => {
      const { data, error } = await supabase
        .from('questions')
        .select(`
          *,
          profiles (username)
        `)
        .eq('id', params.id)
        .single();

      if (error || !data) {
        setLoading(false);
        notFound();
        return;
      }

      setQuestion(data);
      setLoading(false);
    };

    fetchQuestion();
  }, [params.id]);

  if (loading) {
    return (
      <div className="container mx-auto px-4 py-8">
        <div className="animate-pulse">
          <div className="h-8 bg-gray-200 rounded w-3/4 mb-4"></div>
          <div className="h-4 bg-gray-200 rounded w-1/4 mb-8"></div>
          <div className="h-24 bg-gray-200 rounded mb-4"></div>
        </div>
      </div>
    );
  }

  if (!question) {
    return notFound();
  }

  return (
    <div className="container mx-auto px-4 py-8">
      <article className="bg-white rounded-lg shadow-sm p-6">
        <h1 className="text-3xl font-bold mb-4">{question.title}</h1>
        <div className="text-sm text-gray-500 mb-6">
          Asked by {question.profiles?.username || 'Anonymous'} •{' '}
          {formatDistanceToNow(new Date(question.created_at), { addSuffix: true })}
        </div>
        <div className="prose max-w-none">
          {question.content}
        </div>
      </article>
    </div>
  );
}