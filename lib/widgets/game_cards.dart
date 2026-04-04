import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/core/responsive_helper.dart';
import 'package:rrr_flutter_new/models/game_mode.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';

class GameListCard extends StatelessWidget {
  final GameMode game;
  final VoidCallback onTap;
  final VoidCallback onPlayPressed;

  const GameListCard({
    Key? key,
    required this.game,
    required this.onTap,
    required this.onPlayPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        padding: EdgeInsets.all(
          ResponsiveHelper.getResponsivePadding(
            context,
            mobilePadding: 12,
            tabletPadding: 16,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12, width: 1),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.05),
              Colors.white.withOpacity(0.02),
            ],
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent.withOpacity(0.3),
                    Colors.purpleAccent.withOpacity(0.3),
                  ],
                ),
              ),
              child: Icon(
                Icons.sports_esports,
                color: Colors.blueAccent,
                size: 32,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveSubheading(game.name, maxLines: 1),
                  const SizedBox(height: 4),
                  ResponsiveCaption(
                    game.description,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onPlayPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Play',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameTileCard extends StatelessWidget {
  final GameMode game;
  final VoidCallback onTap;
  final VoidCallback onPlayPressed;

  const GameTileCard({
    Key? key,
    required this.game,
    required this.onTap,
    required this.onPlayPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12, width: 1),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.02),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(11)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent.withOpacity(0.2),
                      Colors.purpleAccent.withOpacity(0.2),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.sports_esports,
                    color: Colors.blueAccent,
                    size: 40,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveSubheading(
                    game.name,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  ResponsiveCaption(
                    game.description,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onPlayPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Play'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
