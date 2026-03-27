import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rrr_flutter_new/core/constants/app_values.dart';
import 'package:rrr_flutter_new/models/leaderboard_entry.dart';
import 'package:rrr_flutter_new/services/anti_cheat_service.dart';
import 'package:rrr_flutter_new/services/leaderboard_service.dart';

class TournamentProvider extends ChangeNotifier {
  TournamentProvider({
    required LeaderboardService leaderboardService,
    required AntiCheatService antiCheatService,
  }) : _leaderboardService = leaderboardService,
       _antiCheatService = antiCheatService {
    unawaited(loadLeaderboard());
  }

  final LeaderboardService _leaderboardService;
  final AntiCheatService _antiCheatService;
  List<LeaderboardEntry> _entries = <LeaderboardEntry>[];

  bool _isLoading = false;
  bool _isSubmitting = false;
  bool _joined = false;
  String? _errorMessage;

  List<LeaderboardEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  bool get joined => _joined;
  String? get errorMessage => _errorMessage;
  int get entryFee => AppValues.tournamentEntryFee;
  int get prizePool => AppValues.tournamentPrizePool;

  Future<void> loadLeaderboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _entries = await _leaderboardService.fetchTopPlayers(limit: 50);
    } catch (_) {
      _errorMessage = 'Unable to load leaderboard.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void markJoined() {
    _joined = true;
    notifyListeners();
  }

  Future<String?> submitScore({
    required String playerId,
    required String playerName,
    required int score,
  }) async {
    if (!_joined) {
      return 'Join the tournament before submitting a score.';
    }

    if (!_antiCheatService.isValidScore(
      score: score,
      maxScore: AppValues.maxAllowedScore,
    )) {
      return 'Score rejected by anti-cheat.';
    }

    if (!_antiCheatService.canSubmit(
      playerId: playerId,
      cooldownSeconds: AppValues.tournamentSubmitCooldownSeconds,
    )) {
      return 'Too many submissions. Try again in a few seconds.';
    }

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _entries = await _leaderboardService.submitScore(
        playerName: playerName,
        score: score,
      );
      _antiCheatService.recordSubmission(playerId);
      return null;
    } catch (_) {
      return 'Submission failed. Please retry.';
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
