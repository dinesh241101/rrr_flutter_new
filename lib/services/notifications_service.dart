import 'package:flutter/foundation.dart';

class NotificationsService {
  Future<void> initialize() async {
    debugPrint('Notifications initialized (mock).');
  }

  Future<void> scheduleDailyReminder() async {
    debugPrint('Daily reminder scheduled (mock).');
  }

  Future<void> sendTournamentAlert() async {
    debugPrint('Tournament alert triggered (mock).');
  }
}
