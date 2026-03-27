import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rrr_flutter_new/models/coin_transaction.dart';
import 'package:rrr_flutter_new/services/wallet_sync_service.dart';

class WalletProvider extends ChangeNotifier {
  WalletProvider({required int initialCoins, WalletSyncService? syncService})
    : _coins = initialCoins,
      _syncService = syncService;

  int _coins;
  final List<CoinTransaction> _transactions = <CoinTransaction>[];
  final WalletSyncService? _syncService;

  int get coins => _coins;
  List<CoinTransaction> get transactions => List<CoinTransaction>.unmodifiable(_transactions);

  void addCoins({required int amount, required String source}) {
    if (amount <= 0) {
      return;
    }
    _coins += amount;
    _transactions.insert(
      0,
      CoinTransaction(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        source: source,
        amount: amount,
        isCredit: true,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
    _scheduleSync();
  }

  bool spendCoins({required int amount, required String source}) {
    if (amount <= 0 || amount > _coins) {
      return false;
    }
    _coins -= amount;
    _transactions.insert(
      0,
      CoinTransaction(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        source: source,
        amount: amount,
        isCredit: false,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
    _scheduleSync();
    return true;
  }

  void _scheduleSync() {
    final WalletSyncService? service = _syncService;
    if (service == null) {
      return;
    }
    unawaited(service.syncCoins(totalCoins: _coins));
  }
}
