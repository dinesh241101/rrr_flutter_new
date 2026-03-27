import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/models/game_mode.dart';

class FeaturedGameCard extends StatelessWidget {
  const FeaturedGameCard({
    super.key,
    required this.game,
    required this.onPlay,
  });

  final GameMode game;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  game.name,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Chip(label: Text('+${game.baseReward} coins')),
              ],
            ),
            const SizedBox(height: 8),
            Text(game.description),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: onPlay,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play Now'),
            ),
          ],
        ),
      ),
    );
  }
}
