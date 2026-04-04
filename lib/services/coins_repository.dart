import 'package:rrr_flutter_new/core/supabase_client.dart';
import 'package:rrr_flutter_new/models/supabase_models.dart';

class CoinsRepository {
  static Future<List<CoinTransaction>> getUserTransactions({
    required String userId,
    int limit = 100,
  }) async {
    try {
      final response = await SupabaseClientManager.client
          .from('coin_transactions')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((data) => CoinTransaction.fromJson(data))
          .toList();
    } catch (e) {
      print('Error fetching coin transactions: $e');
      return [];
    }
  }

  static Future<int> getUserCoinBalance(String userId) async {
    try {
      final response = await SupabaseClientManager.client
          .from('user_coins')
          .select('balance')
          .eq('user_id', userId)
          .single();

      return response['balance'] as int? ?? 0;
    } catch (e) {
      print('Error fetching coin balance: $e');
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
    try {
      await SupabaseClientManager.client.from('coin_transactions').insert({
        'user_id': userId,
        'amount': amount,
        'type': type,
        'reason': reason,
        'game_id': gameId,
        'game_name': gameName,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error adding coin transaction: $e');
      rethrow;
    }
  }

  static Future<List<CoinTransaction>> getRecentTransactions({
    required String userId,
    int limit = 10,
  }) async {
    try {
      final response = await SupabaseClientManager.client
          .from('coin_transactions')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((data) => CoinTransaction.fromJson(data))
          .toList();
    } catch (e) {
      print('Error fetching recent transactions: $e');
      return [];
    }
  }
}
