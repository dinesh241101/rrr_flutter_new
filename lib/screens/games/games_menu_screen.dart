import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/core/neon_theme.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';
import 'package:rrr_flutter_new/screens/games/tic_tac_toe_screen.dart';
import 'package:rrr_flutter_new/screens/games/flappy_bird_screen.dart';
import 'package:rrr_flutter_new/screens/games/sudoku_game_screen.dart';
import 'package:rrr_flutter_new/screens/games/game_2048_screen.dart';
import 'package:rrr_flutter_new/screens/games/teen_patti_screen.dart';
import 'package:rrr_flutter_new/screens/games/mines_blast_screen.dart';

class GamesMenuScreen extends StatelessWidget {
  const GamesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      {
        'title': 'Tic Tac Toe',
        'description': 'Classic X and O strategy game',
        'screen': const TicTacToeScreen(),
        'icon': '⭕',
      },
      {
        'title': 'Flappy Bird',
        'description': 'Navigate through obstacles',
        'screen': const FlappyBirdScreen(),
        'icon': '🐦',
      },
      {
        'title': 'Sudoku',
        'description': 'Solve the number puzzle',
        'screen': const SudokuGameScreen(),
        'icon': '🔢',
      },
      {
        'title': '2048',
        'description': 'Merge tiles to reach 2048',
        'screen': const Game2048Screen(),
        'icon': '2️⃣',
      },
      {
        'title': 'Teen Patti',
        'description': 'Card game with betting',
        'screen': const TeenPattiScreen(),
        'icon': '🃏',
      },
      {
        'title': 'Mines Blast',
        'description': 'Click safe tiles, avoid mines',
        'screen': const MinesBlastScreen(),
        'icon': '💣',
      },
    ];

    return Scaffold(
      backgroundColor: NeonTheme.darkBg,
      appBar: AppBar(
        title: const ResponsiveSubheading('Games', color: Colors.white),
        backgroundColor: NeonTheme.darkBg2,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ResponsiveBody('Choose a game to play', color: NeonTheme.neonCyan),
            const SizedBox(height: 24),
            Column(
              children: games.map((game) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => game['screen'] as Widget,
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: NeonTheme.neonCyan, width: 2),
                        borderRadius: BorderRadius.circular(12),
                        color: NeonTheme.darkBg2,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          ResponsiveHeading(game['icon'] as String),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ResponsiveSubheading(
                                  game['title'] as String,
                                  color: NeonTheme.neonLime,
                                ),
                                const SizedBox(height: 4),
                                ResponsiveCaption(
                                  game['description'] as String,
                                  color: NeonTheme.neonCyan.withOpacity(0.7),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: NeonTheme.neonCyan,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
