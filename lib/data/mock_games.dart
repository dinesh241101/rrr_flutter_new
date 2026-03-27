import 'package:rrr_flutter_new/models/game_mode.dart';

class MockGames {
  MockGames._();

  static const List<GameMode> all = <GameMode>[
    GameMode(
      id: 'plinko',
      name: 'Plinko',
      description: 'Drop and score. Highest engagement priority game.',
      baseReward: 20,
    ),
    GameMode(
      id: 'spin_wheel',
      name: 'Spin Wheel',
      description: 'Spin for random rewards and surprise multipliers.',
      baseReward: 15,
    ),
    GameMode(
      id: 'scratch_card',
      name: 'Scratch Card',
      description: 'Reveal hidden values and collect instant coins.',
      baseReward: 12,
    ),
    GameMode(
      id: 'memory_match',
      name: 'Memory Match',
      description: 'Test memory speed and accuracy for bigger rewards.',
      baseReward: 18,
    ),
  ];
}
