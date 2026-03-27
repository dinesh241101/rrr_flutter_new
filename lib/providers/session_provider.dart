import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:rrr_flutter_new/core/constants/app_values.dart';

class SessionProvider extends ChangeNotifier {
  final DateTime _sessionStartedAt = DateTime.now();
  bool _dailyBonusClaimed = false;
  int _adsSeenThisSession = 0;
  int? _lastDailyBonus;

  bool get dailyBonusClaimed => _dailyBonusClaimed;
  int get adsSeenThisSession => _adsSeenThisSession;
  Duration get sessionDuration => DateTime.now().difference(_sessionStartedAt);
  int? get lastDailyBonus => _lastDailyBonus;

  int claimDailyBonus() {
    if (_dailyBonusClaimed) {
      return 0;
    }
    final Random random = Random();
    const int bonusRange =
        AppValues.dailyBonusMaxCoins - AppValues.dailyBonusMinCoins + 1;
    final int amount = AppValues.dailyBonusMinCoins + random.nextInt(bonusRange);

    _dailyBonusClaimed = true;
    _lastDailyBonus = amount;
    notifyListeners();
    return amount;
  }

  void trackAdSeen() {
    _adsSeenThisSession += 1;
    notifyListeners();
  }
}
