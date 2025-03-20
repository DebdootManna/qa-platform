'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { formatDistanceToNow } from 'date-fns';
import { supabase } from '@/lib/supabase/client';

export default function QuestionsPage() {
  const [questions, setQuestions] = useState<any[]>([]);

  useEffect(() => {
    const fetchQuestions = async () => {
      const { data, error } = await supabase
        .from('questions')
        .select(`
          *,
          profiles (username)
        `)
        .order('created_at', { ascending: false });

      if (error) {
        console.error('Error fetching questions:', error);
        return;
      }

      setQuestions(data || []);
    };

    fetchQuestions();
  }, []);

  return (
    <div className="container mx-auto px-4 py-8">
      <div className="flex justify-between items-center mb-8">
        <h1 className="text-3xl font-bold">Recent Questions</h1>
        <Button asChild>
          <Link href="/ask">Ask a Question</Link>
        </Button>
      </div>

      <div className="space-y-4">
        {questions.map((question) => (
          <div
            key={question.id}
            className="border rounded-lg p-6 bg-white shadow-sm hover:shadow-md transition-shadow"
          >
            <Link
              href={`/questions/${question.id}`}
              className="block group"
            >
              <h2 className="text-xl font-semibold group-hover:text-blue-600 transition-colors">
                {question.title}
              </h2>
              <p className="mt-2 text-gray-600 line-clamp-2">
                {question.content}
              </p>
              <div className="mt-4 text-sm text-gray-500">
                Asked by {question.profiles?.username || 'Anonymous'} •{' '}
                {formatDistanceToNow(new Date(question.created_at), {
                  addSuffix: true,
                })}
              </div>
            </Link>
          </div>
        ))}
      </div>
    </div>
  );
}