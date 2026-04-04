import 'package:rrr_flutter_new/core/supabase_client.dart';
import 'package:rrr_flutter_new/models/leaderboard_entry.dart';

class TournamentRepository {
  static Future<List<LeaderboardEntry>> getTopTournamentPlayers({
    int limit = 50,
  }) async {
    try {
      final response = await SupabaseClientManager.client
          .from('tournament_participants')
          .select('user_id, rank, score, prize_won')
          .order('score', ascending: false)
          .order('rank')
          .limit(limit);

      return (response as List).map((data) {
        return LeaderboardEntry(
          rank: data['rank'] as int? ?? 0,
          playerName: 'Player ${data['user_id'].toString().substring(0, 8)}',
          score: data['score'] as int? ?? 0,
          timestamp: DateTime.now(),
        );
      }).toList();
    } catch (e) {
      print('Error fetching tournament leaderboard: $e');
      return [];
    }
  }

  static Future<void> joinTournament({
    required String userId,
    required String tournamentId,
    required int entryFee,
  }) async {
    try {
      await SupabaseClientManager.client
          .from('tournament_participants')
          .insert({
            'user_id': userId,
            'tournament_id': tournamentId,
            'score': 0,
            'rank': null,
            'prize_won': null,
            'joined_at': DateTime.now().toIso8601String(),
            'created_at': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      print('Error joining tournament: $e');
      rethrow;
    }
  }

  static Future<void> submitTournamentScore({
    required String userId,
    required String tournamentId,
    required int score,
  }) async {
    try {
      // First get the participant record
      final participantResponse = await SupabaseClientManager.client
          .from('tournament_participants')
          .select()
          .eq('user_id', userId)
          .eq('tournament_id', tournamentId)
          .single();

      final participantId = participantResponse['id'] as String;

      // Update the score
      await SupabaseClientManager.client
          .from('tournament_participants')
          .update({
            'score': score,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', participantId);
    } catch (e) {
      print('Error submitting tournament score: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getTournamentsByStatus(
    String status,
  ) async {
    try {
      final response = await SupabaseClientManager.client
          .from('tournaments')
          .select()
          .eq('status', status)
          .order('start_time', ascending: true);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print('Error fetching tournaments by status: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getTournamentDetails(
    String tournamentId,
  ) async {
    try {
      final response = await SupabaseClientManager.client
          .from('tournaments')
          .select()
          .eq('id', tournamentId)
          .single();

      return response as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching tournament details: $e');
      return null;
    }
  }

  static Future<bool> isUserParticipant(
    String userId,
    String tournamentId,
  ) async {
    try {
      final response = await SupabaseClientManager.client
          .from('tournament_participants')
          .select('id')
          .eq('user_id', userId)
          .eq('tournament_id', tournamentId);

      return (response as List).isNotEmpty;
    } catch (e) {
      print('Error checking participant status: $e');
      return false;
    }
  }
}
