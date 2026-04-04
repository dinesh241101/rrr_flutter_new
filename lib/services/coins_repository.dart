import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:rrr_flutter_new/core/supabase_client.dart';
import 'package:rrr_flutter_new/models/supabase_models.dart';

class CoinsRepository {
  static Future<List<CoinTransaction>> getUserTransactions({
    required String userId,
    int limit = 100,
  }) async {
    if (!SupabaseClientManager.isInitialized) return [];
    if (!SupabaseClientManager.isConnected) return [];

    try {
      final response = await SupabaseClientManager.client
          .from('coin_transactions')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit)
          .timeout(const Duration(seconds: 15));

      return (response as List)
          .map((data) => CoinTransaction.fromJson(data))
          .toList();
    } on TimeoutException catch (e) {
      debugPrint('Timeout fetching coin transactions: $e');
      return [];
    } on SocketException catch (e) {
      debugPrint('Network error fetching coin transactions: $e');
      return [];
    } catch (e) {
      debugPrint('Error fetching coin transactions: $e');
      return [];
    }
  }

  static Future<int> getUserCoinBalance(String userId) async {
    if (!SupabaseClientManager.isInitialized) return 0;
    if (!SupabaseClientManager.isConnected) return 0;

    try {
      final response = await SupabaseClientManager.client
          .from('user_coins')
          .select('balance')
          .eq('user_id', userId)
          .single()
          .timeout(const Duration(seconds: 15));

      return response['balance'] as int? ?? 0;
    } on TimeoutException catch (e) {
      debugPrint('Timeout fetching coin balance: $e');
      return 0;
    } on SocketException catch (e) {
      debugPrint('Network error fetching coin balance: $e');
      return 0;
    } catch (e) {
      debugPrint('Error fetching coin balance: $e');
      return 0;
    }
  }

  static Future<void> addCoinTransaction({
    required String userId,
    required int amount,
    required String type,
    required String reason,
    String? gameId,
    String? gameName,
  }) async {
    if (!SupabaseClientManager.isInitialized) return;
    if (!SupabaseClientManager.isConnected) return;

    try {
      await SupabaseClientManager.client
          .from('coin_transactions')
          .insert({
            'user_id': userId,
            'amount': amount,
            'type': type,
            'reason': reason,
            'game_id': gameId,
            'game_name': gameName,
            'created_at': DateTime.now().toIso8601String(),
          })
          .timeout(const Duration(seconds: 10));
    } on TimeoutException catch (e) {
      debugPrint('Timeout adding coin transaction: $e');
    } on SocketException catch (e) {
      debugPrint('Network error adding coin transaction: $e');
    } catch (e) {
      debugPrint('Error adding coin transaction: $e');
    }
  }

  static Future<List<CoinTransaction>> getRecentTransactions({
    required String userId,
    int limit = 10,
  }) async {
    if (!SupabaseClientManager.isInitialized) return [];
    if (!SupabaseClientManager.isConnected) return [];

    try {
      final response = await SupabaseClientManager.client
          .from('coin_transactions')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit)
          .timeout(const Duration(seconds: 15));

      return (response as List)
          .map((data) => CoinTransaction.fromJson(data))
          .toList();
    } on TimeoutException catch (e) {
      debugPrint('Timeout fetching recent transactions: $e');
      return [];
    } on SocketException catch (e) {
      debugPrint('Network error fetching recent transactions: $e');
      return [];
    } catch (e) {
      debugPrint('Error fetching recent transactions: $e');
      return [];
    }
  }
}
