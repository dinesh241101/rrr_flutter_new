class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.playerName,
    required this.score,
    required this.timestamp,
  });

  final int rank;
  final String playerName;
  final int score;
  final DateTime timestamp;

  LeaderboardEntry copyWith({
    int? rank,
    String? playerName,
    int? score,
    DateTime? timestamp,
  }) {
    return LeaderboardEntry(
      rank: rank ?? this.rank,
      playerName: playerName ?? this.playerName,
      score: score ?? this.score,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
