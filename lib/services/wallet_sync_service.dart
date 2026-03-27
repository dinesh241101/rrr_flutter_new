import 'package:flutter/foundation.dart';

abstract class WalletSyncService {
  Future<void> syncCoins({required int totalCoins});
}

class MockWalletSyncService implements WalletSyncService {
  @override
  Future<void> syncCoins({required int totalCoins}) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    debugPrint('Wallet synced (mock) -> totalCoins: $totalCoins');
  }
}
