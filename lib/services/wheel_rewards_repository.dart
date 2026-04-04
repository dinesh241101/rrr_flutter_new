import 'dart:math' as math;
import 'package:rrr_flutter_new/core/supabase_client.dart'
    show SupabaseClientManager;

class WheelReward {
  final int id;
  final String name;
  final int coinReward;
  final double probability; // 0.0 to 1.0
  final String description;
  final bool isActive;

  WheelReward({
    required this.id,
    required this.name,
    required this.coinReward,
    required this.probability,
    required this.description,
    required this.isActive,
  });

  factory WheelReward.fromMap(Map<String, dynamic> map) {
    return WheelReward(
      id: map['id'] as int,
      name: map['name'] as String,
      coinReward: map['coin_reward'] as int,
      probability: (map['probability'] as num).toDouble(),
      description: map['description'] as String? ?? '',
      isActive: map['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'coin_reward': coinReward,
      'probability': probability,
      'description': description,
      'is_active': isActive,
    };
  }
}

class WheelRewardsRepository {
  static Future<List<WheelReward>> getActiveRewards() async {
    try {
      final response = await SupabaseClientManager.client
          .from('wheel_rewards')
          .select()
          .eq('is_active', true)
          .order('probability', ascending: false);

      if (response is List) {
        return (response).map((item) => WheelReward.fromMap(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching wheel rewards: $e');
      return _getDefaultRewards(); // Fallback to defaults
    }
  }

  static List<WheelReward> _getDefaultRewards() {
    return [
      WheelReward(
        id: 1,
        name: '🎉 Jackpot!',
        coinReward: 500,
        probability: 0.05,
        description: 'Lucky Golden Prize',
        isActive: true,
      ),
      WheelReward(
        id: 2,
        name: '🌟 Premium',
        coinReward: 250,
        probability: 0.15,
        description: 'Great Fortune',
        isActive: true,
      ),
      WheelReward(
        id: 3,
        name: '🎁 Bonus',
        coinReward: 100,
        probability: 0.30,
        description: 'Nice Reward',
        isActive: true,
      ),
      WheelReward(
        id: 4,
        name: '💰 Regular',
        coinReward: 50,
        probability: 0.35,
        description: 'Standard Prize',
        isActive: true,
      ),
      WheelReward(
        id: 5,
        name: '✨ Small',
        coinReward: 25,
        probability: 0.15,
        description: 'Try Again!',
        isActive: true,
      ),
    ];
  }

  static Future<WheelReward?> selectRandomReward() async {
    try {
      final rewards = await getActiveRewards();
      if (rewards.isEmpty) return null;

      // Weighted random selection based on probability
      double random = (math.Random().nextDouble());
      double cumulativeProbability = 0;

      for (var reward in rewards) {
        cumulativeProbability += reward.probability;
        if (random <= cumulativeProbability) {
          return reward;
        }
      }

      // Fallback to last reward
      return rewards.last;
    } catch (e) {
      print('Error selecting random reward: $e');
      return null;
    }
  }

  static Future<bool> submitRewardClaim({
    required String userId,
    required int rewardId,
    required int coinsEarned,
    required String source, // 'spin_wheel', 'scratch_card', 'daily_bonus', etc.
  }) async {
    try {
      await SupabaseClientManager.client.from('coin_transactions').insert({
        'user_id': userId,
        'amount': coinsEarned,
        'transaction_type': 'reward',
        'source': source,
        'related_reward_id': rewardId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'description': 'Reward claimed from $source',
      });

      // Also update wheel_reward_claims table for analytics
      await SupabaseClientManager.client.from('wheel_reward_claims').insert({
        'user_id': userId,
        'reward_id': rewardId,
        'coins_earned': coinsEarned,
        'source': source,
        'claimed_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print('Error submitting reward claim: $e');
      return false;
    }
  }

  static Future<int> getUserRewardClaimsCount({
    required String userId,
    String? source,
  }) async {
    try {
      var query = SupabaseClientManager.client
          .from('wheel_reward_claims')
          .select('id')
          .eq('user_id', userId);

      if (source != null) {
        query = query.eq('source', source);
      }

      final response = await query;
      return (response as List).length;
    } catch (e) {
      print('Error fetching reward claims count: $e');
      return 0;
    }
  }

  static Future<List<Map<String, dynamic>>> getUserRewardHistory({
    required String userId,
    int limit = 10,
  }) async {
    try {
      final response = await SupabaseClientManager.client
          .from('coin_transactions')
          .select()
          .eq('user_id', userId)
          .eq('transaction_type', 'reward')
          .order('timestamp', ascending: false)
          .limit(limit);

      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      print('Error fetching reward history: $e');
      return [];
    }
  }
}
