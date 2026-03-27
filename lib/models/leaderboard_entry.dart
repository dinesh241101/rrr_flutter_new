class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.playerName,
    required this.score,
  });

  final int rank;
  final String playerName;
  final int score;

  LeaderboardEntry copyWith({int? rank, String? playerName, int? score}) {
    return LeaderboardEntry(
      rank: rank ?? this.rank,
      playerName: playerName ?? this.playerName,
      score: score ?? this.score,
    );
  }
}
