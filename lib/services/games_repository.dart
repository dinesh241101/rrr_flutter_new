import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:rrr_flutter_new/core/supabase_client.dart';
import 'package:rrr_flutter_new/models/supabase_models.dart';

class GamesRepository {
  static Future<List<GameScore>> getTopGameScores(
    String gameId, {
    int limit = 10,
  }) async {
    if (!SupabaseClientManager.isInitialized) return [];
    if (!SupabaseClientManager.isConnected) return [];

    try {
      final response = await SupabaseClientManager.client
          .from('game_scores')
          .select()
          .eq('game_id', gameId)
          .order('score', ascending: false)
          .limit(limit)
          .timeout(const Duration(seconds: 15));

      return (response as List)
          .map((data) => GameScore.fromJson(data))
          .toList();
    } on TimeoutException catch (e) {
      debugPrint('Timeout fetching top game scores: $e');
      return [];
    } on SocketException catch (e) {
      debugPrint('Network error fetching top game scores: $e');
      return [];
    } catch (e) {
      debugPrint('Error fetching top game scores: $e');
      return [];
    }
  }

  static Future<List<GameScore>> getUserGameScores(
    String userId, {
    int limit = 50,
  }) async {
    if (!SupabaseClientManager.isInitialized) return [];
    if (!SupabaseClientManager.isConnected) return [];

    try {
      final response = await SupabaseClientManager.client
          .from('game_scores')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit)
          .timeout(const Duration(seconds: 15));

      return (response as List)
          .map((data) => GameScore.fromJson(data))
          .toList();
    } on TimeoutException catch (e) {
      debugPrint('Timeout fetching user game scores: $e');
      return [];
    } on SocketException catch (e) {
      debugPrint('Network error fetching user game scores: $e');
      return [];
    } catch (e) {
      debugPrint('Error fetching user game scores: $e');
      return [];
    }
  }

  static Future<GameConfig?> getGameConfig(String gameId) async {
    if (!SupabaseClientManager.isInitialized) return null;
    if (!SupabaseClientManager.isConnected) return null;

    try {
      final response = await SupabaseClientManager.client
          .from('game_configs')
          .select()
          .eq('game_id', gameId)
          .single()
          .timeout(const Duration(seconds: 15));

      return GameConfig.fromJson(response);
    } on TimeoutException catch (e) {
      debugPrint('Timeout fetching game config: $e');
      return null;
    } on SocketException catch (e) {
      debugPrint('Network error fetching game config: $e');
      return null;
    } catch (e) {
      debugPrint('Error fetching game config: $e');
      return null;
    }
  }

  static Future<List<GameScore>> getUserRecentGameScores({
    required String userId,
    int limit = 5,
  }) async {
    if (!SupabaseClientManager.isInitialized) return [];
    if (!SupabaseClientManager.isConnected) return [];

    try {
      final response = await SupabaseClientManager.client
          .from('game_scores')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit)
          .timeout(const Duration(seconds: 15));

      return (response as List)
          .map((data) => GameScore.fromJson(data))
          .toList();
    } on TimeoutException catch (e) {
      debugPrint('Timeout fetching recent game scores: $e');
      return [];
    } on SocketException catch (e) {
      debugPrint('Network error fetching recent game scores: $e');
      return [];
    } catch (e) {
      debugPrint('Error fetching recent game scores: $e');
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
    if (!SupabaseClientManager.isInitialized) return;
    if (!SupabaseClientManager.isConnected) return;

    try {
      await SupabaseClientManager.client
          .from('game_scores')
          .insert({
            'user_id': userId,
            'game_id': gameId,
            'game_name': gameName,
            'score': score,
            'time_taken': timeTaken,
            'created_at': DateTime.now().toIso8601String(),
          })
          .timeout(const Duration(seconds: 10));
    } on TimeoutException catch (e) {
      debugPrint('Timeout submitting game score: $e');
    } on SocketException catch (e) {
      debugPrint('Network error submitting game score: $e');
    } catch (e) {
      debugPrint('Error submitting game score: $e');
    }
  }
}
