import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:rrr_flutter_new/core/supabase_client.dart';
import 'package:rrr_flutter_new/models/leaderboard_entry.dart';

class TournamentRepository {
  static Future<List<LeaderboardEntry>> getTopTournamentPlayers({
    int limit = 50,
  }) async {
    if (!SupabaseClientManager.isInitialized) return [];
    if (!SupabaseClientManager.isConnected) return [];

    try {
      final response = await SupabaseClientManager.client
          .from('tournament_participants')
          .select('user_id, rank, score, prize_won')
          .order('score', ascending: false)
          .order('rank')
          .limit(limit)
          .timeout(const Duration(seconds: 15));

      return (response as List).map((data) {
        return LeaderboardEntry(
          rank: data['rank'] as int? ?? 0,
          playerName: 'Player ${data['user_id'].toString().substring(0, 8)}',
          score: data['score'] as int? ?? 0,
          timestamp: DateTime.now(),
        );
      }).toList();
    } on TimeoutException catch (e) {
      debugPrint('Timeout fetching tournament leaderboard: $e');
      return [];
    } on SocketException catch (e) {
      debugPrint('Network error fetching tournament leaderboard: $e');
      return [];
    } catch (e) {
      debugPrint('Error fetching tournament leaderboard: $e');
      return [];
    }
  }

  static Future<void> joinTournament({
    required String userId,
    required String tournamentId,
    required int entryFee,
  }) async {
    if (!SupabaseClientManager.isInitialized) return;
    if (!SupabaseClientManager.isConnected) return;

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
          })
          .timeout(const Duration(seconds: 10));
    } on TimeoutException catch (e) {
      debugPrint('Timeout joining tournament: $e');
    } on SocketException catch (e) {
      debugPrint('Network error joining tournament: $e');
    } catch (e) {
      debugPrint('Error joining tournament: $e');
    }
  }

  static Future<void> submitTournamentScore({
    required String userId,
    required String tournamentId,
    required int score,
  }) async {
    if (!SupabaseClientManager.isInitialized) return;
    if (!SupabaseClientManager.isConnected) return;

    try {
      // First get the participant record
      final participantResponse = await SupabaseClientManager.client
          .from('tournament_participants')
          .select()
          .eq('user_id', userId)
          .eq('tournament_id', tournamentId)
          .single()
          .timeout(const Duration(seconds: 10));

      final participantId = participantResponse['id'] as String;

      // Update the score
      await SupabaseClientManager.client
          .from('tournament_participants')
          .update({
            'score': score,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', participantId)
          .timeout(const Duration(seconds: 10));
    } on TimeoutException catch (e) {
      debugPrint('Timeout submitting tournament score: $e');
    } on SocketException catch (e) {
      debugPrint('Network error submitting tournament score: $e');
    } catch (e) {
      debugPrint('Error submitting tournament score: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getTournamentsByStatus(
    String status,
  ) async {
    if (!SupabaseClientManager.isInitialized) return [];
    if (!SupabaseClientManager.isConnected) return [];

    try {
      final response = await SupabaseClientManager.client
          .from('tournaments')
          .select()
          .eq('status', status)
          .order('start_time', ascending: true)
          .timeout(const Duration(seconds: 15));

      return List<Map<String, dynamic>>.from(response as List);
    } on TimeoutException catch (e) {
      debugPrint('Timeout fetching tournaments by status: $e');
      return [];
    } on SocketException catch (e) {
      debugPrint('Network error fetching tournaments by status: $e');
      return [];
    } catch (e) {
      debugPrint('Error fetching tournaments by status: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getTournamentDetails(
    String tournamentId,
  ) async {
    if (!SupabaseClientManager.isInitialized) return null;
    if (!SupabaseClientManager.isConnected) return null;

    try {
      final response = await SupabaseClientManager.client
          .from('tournaments')
          .select()
          .eq('id', tournamentId)
          .single()
          .timeout(const Duration(seconds: 15));

      return response;
    } on TimeoutException catch (e) {
      debugPrint('Timeout fetching tournament details: $e');
      return null;
    } on SocketException catch (e) {
      debugPrint('Network error fetching tournament details: $e');
      return null;
    } catch (e) {
      debugPrint('Error fetching tournament details: $e');
      return null;
    }
  }

  static Future<bool> isUserParticipant(
    String userId,
    String tournamentId,
  ) async {
    if (!SupabaseClientManager.isInitialized) return false;
    if (!SupabaseClientManager.isConnected) return false;

    try {
      final response = await SupabaseClientManager.client
          .from('tournament_participants')
          .select('id')
          .eq('user_id', userId)
          .eq('tournament_id', tournamentId)
          .timeout(const Duration(seconds: 15));

      return (response as List).isNotEmpty;
    } on TimeoutException catch (e) {
      debugPrint('Timeout checking participant status: $e');
      return false;
    } on SocketException catch (e) {
      debugPrint('Network error checking participant status: $e');
      return false;
    } catch (e) {
      debugPrint('Error checking participant status: $e');
      return false;
    }
  }
}
