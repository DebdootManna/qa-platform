import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import Link from 'next/link';
import { MessageCircle, Star, Users } from 'lucide-react';

export default function Home() {
  return (
    <main className="min-h-screen bg-gradient-to-b from-gray-50 to-white">
      {/* Hero Section */}
      <div className="container mx-auto px-4 py-16">
        <div className="text-center">
          <h1 className="text-4xl font-bold tracking-tight text-gray-900 sm:text-6xl">
            Your Knowledge Sharing Community
          </h1>
          <p className="mt-6 text-lg leading-8 text-gray-600">
            Ask questions, share your expertise, and learn from others in a
            supportive environment.
          </p>
          <div className="mt-10 flex items-center justify-center gap-x-6">
            <Button asChild size="lg">
              <Link href="/questions">Browse Questions</Link>
            </Button>
            <Button asChild variant="outline" size="lg">
              <Link href="/ask">Ask a Question</Link>
            </Button>
          </div>
        </div>
      </div>

      {/* Features Section */}
      <div className="py-16 bg-white">
        <div className="container mx-auto px-4">
          <div className="grid md:grid-cols-3 gap-8">
            <Card className="p-6">
              <MessageCircle className="h-12 w-12 text-primary mb-4" />
              <h3 className="text-xl font-semibold mb-2">Ask Questions</h3>
              <p className="text-gray-600">
                Get answers from experts in the community. Ask anonymously or with
                your profile.
              </p>
            </Card>

            <Card className="p-6">
              <Star className="h-12 w-12 text-primary mb-4" />
              <h3 className="text-xl font-semibold mb-2">Rate Answers</h3>
              <p className="text-gray-600">
                Help others find the best answers by rating responses and building
                trust.
              </p>
            </Card>

            <Card className="p-6">
              <Users className="h-12 w-12 text-primary mb-4" />
              <h3 className="text-xl font-semibold mb-2">Build Reputation</h3>
              <p className="text-gray-600">
                Share your knowledge and earn recognition from the community.
              </p>
            </Card>
          </div>
        </div>
      </div>
    </main>
  );
}