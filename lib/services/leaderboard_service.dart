import 'dart:math';

import 'package:rrr_flutter_new/models/leaderboard_entry.dart';

abstract class LeaderboardService {
  Future<List<LeaderboardEntry>> fetchTopPlayers({required int limit});
  Future<List<LeaderboardEntry>> submitScore({
    required String playerName,
    required int score,
  });
}

class MockLeaderboardService implements LeaderboardService {
  final List<LeaderboardEntry> _entries = List<LeaderboardEntry>.generate(
    25,
    (int index) => LeaderboardEntry(
      rank: index + 1,
      playerName: 'Player_${index + 1}',
      score: 2000 - (index * 53),
      timestamp: DateTime.now().subtract(Duration(days: index)),
    ),
  );

  @override
  Future<List<LeaderboardEntry>> fetchTopPlayers({required int limit}) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    return _sortedWithRanks().take(limit).toList(growable: false);
  }

  @override
  Future<List<LeaderboardEntry>> submitScore({
    required String playerName,
    required int score,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 280));
    final int boostedScore = score + Random().nextInt(20);
    final int existingIndex = _entries.indexWhere(
      (LeaderboardEntry entry) => entry.playerName == playerName,
    );

    if (existingIndex >= 0) {
      final int current = _entries[existingIndex].score;
      _entries[existingIndex] = _entries[existingIndex].copyWith(
        score: max(current, boostedScore),
      );
    } else {
      _entries.add(
        LeaderboardEntry(
          rank: _entries.length + 1,
          playerName: playerName,
          score: boostedScore,
          timestamp: DateTime.now(),
        ),
      );
    }

    return _sortedWithRanks().take(50).toList(growable: false);
  }

  List<LeaderboardEntry> _sortedWithRanks() {
    final List<LeaderboardEntry> sorted = List<LeaderboardEntry>.from(_entries)
      ..sort(
        (LeaderboardEntry a, LeaderboardEntry b) => b.score.compareTo(a.score),
      );

    return sorted
        .asMap()
        .entries
        .map(
          (MapEntry<int, LeaderboardEntry> row) =>
              row.value.copyWith(rank: row.key + 1),
        )
        .toList(growable: false);
  }
}
