import 'package:rrr_flutter_new/core/supabase_client.dart';
import 'package:rrr_flutter_new/models/supabase_models.dart';

class GamesRepository {
  static Future<List<GameScore>> getTopGameScores(
    String gameId, {
    int limit = 10,
  }) async {
    try {
      final response = await SupabaseClientManager.client
          .from('game_scores')
          .select()
          .eq('game_id', gameId)
          .order('score', ascending: false)
          .limit(limit);

      return (response as List)
          .map((data) => GameScore.fromJson(data))
          .toList();
    } catch (e) {
      print('Error fetching top game scores: $e');
      return [];
    }
  }

  static Future<List<GameScore>> getUserGameScores(
    String userId, {
    int limit = 50,
  }) async {
    try {
      final response = await SupabaseClientManager.client
          .from('game_scores')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((data) => GameScore.fromJson(data))
          .toList();
    } catch (e) {
      print('Error fetching user game scores: $e');
      return [];
    }
  }

  static Future<GameConfig?> getGameConfig(String gameId) async {
    try {
      final response = await SupabaseClientManager.client
          .from('game_configs')
          .select()
          .eq('game_id', gameId)
          .single();

      return GameConfig.fromJson(response);
    } catch (e) {
      print('Error fetching game config: $e');
      return null;
    }
  }

  static Future<List<GameScore>> getUserRecentGameScores({
    required String userId,
    int limit = 5,
  }) async {
    try {
      final response = await SupabaseClientManager.client
          .from('game_scores')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((data) => GameScore.fromJson(data))
          .toList();
    } catch (e) {
      print('Error fetching recent game scores: $e');
      return [];
    }
  }

  static Future<void> submitGameScore({
    required String userId,
    required String gameId,
    required String gameName,
    required int score,
    int? timeTaken,
  }) async {
    try {
      await SupabaseClientManager.client.from('game_scores').insert({
        'user_id': userId,
        'game_id': gameId,
        'game_name': gameName,
        'score': score,
        'time_taken': timeTaken,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error submitting game score: $e');
      rethrow;
    }
  }
}
