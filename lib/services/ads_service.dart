import 'package:flutter/foundation.dart';

class AdsService {
  AdsService._();

  static final AdsService instance = AdsService._();

  int _interstitialShown = 0;
  int _rewardedShown = 0;

  int get interstitialShown => _interstitialShown;
  int get rewardedShown => _rewardedShown;
  int get totalAdsShown => _interstitialShown + _rewardedShown;

  Future<bool> showInterstitial({required String placement}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _interstitialShown += 1;
    debugPrint(
      'Mock Interstitial shown at $placement. Total: $totalAdsShown',
    );
    return true;
  }

  Future<int?> showRewarded({
    required String placement,
    required int rewardCoins,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _rewardedShown += 1;
    debugPrint('Mock Rewarded shown at $placement. Reward: $rewardCoins');
    return rewardCoins;
  }
}
