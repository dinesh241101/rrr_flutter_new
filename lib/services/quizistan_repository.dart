import 'package:rrr_flutter_new/core/supabase_client.dart';
import 'package:rrr_flutter_new/models/supabase_models.dart';

class QuizistanRepository {
  static Future<List<QuizistanQuiz>> getActiveQuizzes() async {
    try {
      final response = await SupabaseClientManager.client
          .from('quizistan_quizzes')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((data) => QuizistanQuiz.fromJson(data))
          .toList();
    } catch (e) {
      print('Error fetching active quizzes: $e');
      return [];
    }
  }

  static Future<List<QuizistanQuiz>> getQuizzesByGenre(String genre) async {
    try {
      final response = await SupabaseClientManager.client
          .from('quizistan_quizzes')
          .select()
          .eq('genre', genre)
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((data) => QuizistanQuiz.fromJson(data))
          .toList();
    } catch (e) {
      print('Error fetching quizzes by genre: $e');
      return [];
    }
  }

  static Future<QuizistanQuiz?> getQuizDetails(String quizId) async {
    try {
      final response = await SupabaseClientManager.client
          .from('quizistan_quizzes')
          .select()
          .eq('id', quizId)
          .single();

      return QuizistanQuiz.fromJson(response);
    } catch (e) {
      print('Error fetching quiz details: $e');
      return null;
    }
  }

  static Future<List<QuizistanAttempt>> getUserQuizAttempts(
    String userId,
  ) async {
    try {
      final response = await SupabaseClientManager.client
          .from('quizistan_attempts')
          .select()
          .eq('user_id', userId)
          .order('completed_at', ascending: false);

      return (response as List)
          .map((data) => QuizistanAttempt.fromJson(data))
          .toList();
    } catch (e) {
      print('Error fetching user quiz attempts: $e');
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
      await SupabaseClientManager.client.from('quizistan_attempts').insert({
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
      });
    } catch (e) {
      print('Error submitting quiz attempt: $e');
      rethrow;
    }
  }

  static Future<List<QuizistanQuiz>> getFeaturedQuizzes({int limit = 5}) async {
    try {
      final response = await SupabaseClientManager.client
          .from('quizistan_quizzes')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((data) => QuizistanQuiz.fromJson(data))
          .toList();
    } catch (e) {
      print('Error fetching featured quizzes: $e');
      return [];
    }
  }
}
