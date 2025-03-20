export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string
          username: string | null
          bio: string | null
          avatar_url: string | null
          is_anonymous: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          username?: string | null
          bio?: string | null
          avatar_url?: string | null
          is_anonymous?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          username?: string | null
          bio?: string | null
          avatar_url?: string | null
          is_anonymous?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      questions: {
        Row: {
          id: string
          title: string
          content: string
          author_id: string | null
          is_anonymous: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          title: string
          content: string
          author_id?: string | null
          is_anonymous?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          title?: string
          content?: string
          author_id?: string | null
          is_anonymous?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      answers: {
        Row: {
          id: string
          content: string
          question_id: string
          author_id: string | null
          is_anonymous: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          content: string
          question_id: string
          author_id?: string | null
          is_anonymous?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          content?: string
          question_id?: string
          author_id?: string | null
          is_anonymous?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      ratings: {
        Row: {
          id: string
          answer_id: string
          user_id: string
          rating: number
          created_at: string
        }
        Insert: {
          id?: string
          answer_id: string
          user_id: string
          rating: number
          created_at?: string
        }
        Update: {
          id?: string
          answer_id?: string
          user_id?: string
          rating?: number
          created_at?: string
        }
      }
      tags: {
        Row: {
          id: string
          name: string
          created_at: string
        }
        Insert: {
          id?: string
          name: string
          created_at?: string
        }
        Update: {
          id?: string
          name?: string
          created_at?: string
        }
      }
      question_tags: {
        Row: {
          question_id: string
          tag_id: string
        }
        Insert: {
          question_id: string
          tag_id: string
        }
        Update: {
          question_id?: string
          tag_id?: string
        }
      }
    }
    Functions: {
      get_answer_rating: {
        Args: {
          answer_uuid: string
        }
        Returns: number
      }
      get_user_rating: {
        Args: {
          user_uuid: string
        }
        Returns: number
      }
    }
  }
}