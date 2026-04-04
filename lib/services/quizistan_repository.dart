import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:rrr_flutter_new/core/supabase_client.dart';
import 'package:rrr_flutter_new/models/supabase_models.dart';

class QuizistanRepository {
  static Future<List<QuizistanQuiz>> getActiveQuizzes() async {
    try {
      // Check if Supabase is initialized
      if (!SupabaseClientManager.isInitialized) {
        debugPrint('Supabase not initialized. Skipping quiz fetch.');
        return [];
      }

      // Check network connectivity
      if (!SupabaseClientManager.isConnected) {
        debugPrint('No internet connection. Cannot fetch quizzes.');
        return [];
      }

      final response = await SupabaseClientManager.client
          .from('quizistan_quizzes')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw TimeoutException('Quiz fetch timeout'),
          );

      return (response as List)
          .map((data) => QuizistanQuiz.fromJson(data))
          .toList();
    } on TimeoutException catch (e) {
      debugPrint('Timeout fetching active quizzes: $e');
      return [];
    } on SocketException catch (e) {
      debugPrint('Network error fetching quizzes: $e');
      return [];
    } catch (e) {
      debugPrint('Error fetching active quizzes: $e');
      return [];
    }
  }

  static Future<List<QuizistanQuiz>> getQuizzesByGenre(String genre) async {
    try {
      if (!SupabaseClientManager.isInitialized) {
        debugPrint('Supabase not initialized.');
        return [];
      }

      if (!SupabaseClientManager.isConnected) {
        debugPrint('No internet connection.');
        return [];
      }

      final response = await SupabaseClientManager.client
          .from('quizistan_quizzes')
          .select()
          .eq('genre', genre)
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw TimeoutException('Quiz fetch timeout'),
          );

      return (response as List)
          .map((data) => QuizistanQuiz.fromJson(data))
          .toList();
    } on TimeoutException catch (e) {
      debugPrint('Timeout fetching quizzes by genre: $e');
      return [];
    } on SocketException catch (e) {
      debugPrint('Network error fetching quizzes by genre: $e');
      return [];
    } catch (e) {
      debugPrint('Error fetching quizzes by genre: $e');
      return [];
    }
  }

  static Future<QuizistanQuiz?> getQuizDetails(String quizId) async {
    try {
      if (!SupabaseClientManager.isInitialized) {
        return null;
      }

      if (!SupabaseClientManager.isConnected) {
        return null;
      }

      final response = await SupabaseClientManager.client
          .from('quizistan_quizzes')
          .select()
          .eq('id', quizId)
          .single()
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () =>
                throw TimeoutException('Quiz details fetch timeout'),
          );

      return QuizistanQuiz.fromJson(response);
    } on TimeoutException catch (e) {
      debugPrint('Timeout fetching quiz details: $e');
      return null;
    } on SocketException catch (e) {
      debugPrint('Network error fetching quiz details: $e');
      return null;
    } catch (e) {
      debugPrint('Error fetching quiz details: $e');
      return null;
    }
  }

  static Future<List<QuizistanAttempt>> getUserQuizAttempts(
    String userId,
  ) async {
    try {
      if (!SupabaseClientManager.isInitialized) {
        return [];
      }

      if (!SupabaseClientManager.isConnected) {
        return [];
      }

      final response = await SupabaseClientManager.client
          .from('quizistan_attempts')
          .select()
          .eq('user_id', userId)
          .order('completed_at', ascending: false)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw TimeoutException('Attempts fetch timeout'),
          );

      return (response as List)
          .map((data) => QuizistanAttempt.fromJson(data))
          .toList();
    } on TimeoutException catch (e) {
      debugPrint('Timeout fetching user quiz attempts: $e');
      return [];
    } on SocketException catch (e) {
      debugPrint('Network error fetching user quiz attempts: $e');
      return [];
    } catch (e) {
      debugPrint('Error fetching user quiz attempts: $e');
      return [];
    }
  }

  static Future<void> submitQuizAttempt({
    required String userId,
    required String quizId,
    required int score,
    required int correctAnswers,
    required int totalQuestions,
    required int coinsEarned,
    int? timeTaken,
    int? streakCount,
    String? tierName,
  }) async {
    try {
      if (!SupabaseClientManager.isInitialized) {
        debugPrint('Supabase not initialized. Cannot submit quiz attempt.');
        return;
      }

      if (!SupabaseClientManager.isConnected) {
        debugPrint('No internet connection. Cannot submit quiz attempt.');
        return;
      }

      await SupabaseClientManager.client
          .from('quizistan_attempts')
          .insert({
            'user_id': userId,
            'quiz_id': quizId,
            'score': score,
            'correct_answers': correctAnswers,
            'total_questions': totalQuestions,
            'coins_earned': coinsEarned,
            'time_taken': timeTaken,
            'streak_count': streakCount ?? 0,
            'tier_name': tierName,
            'completed_at': DateTime.now().toIso8601String(),
            'created_at': DateTime.now().toIso8601String(),
          })
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () =>
                throw TimeoutException('Submit quiz attempt timeout'),
          );
    } on TimeoutException catch (e) {
      debugPrint('Timeout submitting quiz attempt: $e');
    } on SocketException catch (e) {
      debugPrint('Network error submitting quiz attempt: $e');
    } catch (e) {
      debugPrint('Error submitting quiz attempt: $e');
    }
  }

  static Future<List<QuizistanQuiz>> getFeaturedQuizzes({int limit = 5}) async {
    try {
      if (!SupabaseClientManager.isInitialized) {
        return [];
      }

      if (!SupabaseClientManager.isConnected) {
        return [];
      }

      final response = await SupabaseClientManager.client
          .from('quizistan_quizzes')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(limit)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () =>
                throw TimeoutException('Featured quizzes fetch timeout'),
          );

      return (response as List)
          .map((data) => QuizistanQuiz.fromJson(data))
          .toList();
    } on TimeoutException catch (e) {
      debugPrint('Timeout fetching featured quizzes: $e');
      return [];
    } on SocketException catch (e) {
      debugPrint('Network error fetching featured quizzes: $e');
      return [];
    } catch (e) {
      debugPrint('Error fetching featured quizzes: $e');
      return [];
    }
  }
}
