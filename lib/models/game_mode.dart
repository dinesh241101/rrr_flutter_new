class GameMode {
  const GameMode({
    required this.id,
    required this.name,
    required this.description,
    required this.baseReward,
  });

  final String id;
  final String name;
  final String description;
  final int baseReward;
}
