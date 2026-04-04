import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/core/neon_theme.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';

class MinesBlastScreen extends StatefulWidget {
  const MinesBlastScreen({super.key});

  @override
  State<MinesBlastScreen> createState() => _MinesBlastScreenState();
}

class _MinesBlastScreenState extends State<MinesBlastScreen> {
  late List<bool> grid;
  late List<bool> revealed;
  late List<int> minePositions;
  int score = 0;
  int safeTilesClicked = 0;
  int totalMines = 10;
  int gridSize = 25;
  bool gameOver = false;
  bool gameWon = false;
  bool gameStarted = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    grid = List.filled(gridSize, false);
    revealed = List.filled(gridSize, false);

    // Generate random mine positions
    List<int> positions = List.generate(gridSize, (i) => i);
    positions.shuffle();
    minePositions = positions.take(totalMines).toList();

    for (int pos in minePositions) {
      grid[pos] = true;
    }

    score = 0;
    safeTilesClicked = 0;
    gameOver = false;
    gameWon = false;
    gameStarted = false;
  }

  void _revealTile(int index) {
    if (!gameStarted) {
      setState(() {
        gameStarted = true;
      });
    }

    if (revealed[index] || gameOver || gameWon) {
      return;
    }

    setState(() {
      revealed[index] = true;

      if (grid[index]) {
        // Hit a mine
        gameOver = true;
        _revealAllMines();
      } else {
        // Safe tile
        safeTilesClicked++;
        score += 10;

        // Check if all safe tiles are revealed
        if (safeTilesClicked == gridSize - totalMines) {
          gameWon = true;
          score += 500; // Bonus for completing
        }
      }
    });
  }

  void _revealAllMines() {
    setState(() {
      for (int pos in minePositions) {
        revealed[pos] = true;
      }
    });
  }

  void _cashOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NeonTheme.darkBg2,
        title: ResponsiveSubheading('Cash Out!', color: NeonTheme.neonLime),
        content: ResponsiveBody('You won \$${score}!', color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _initializeGame();
              });
            },
            child: ResponsiveBody('Play Again', color: NeonTheme.neonCyan),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int cols = 5;

    return Scaffold(
      backgroundColor: NeonTheme.darkBg,
      appBar: AppBar(
        title: const ResponsiveSubheading('Mines Blast', color: Colors.white),
        backgroundColor: NeonTheme.darkBg2,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Stats Display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    ResponsiveBody('Score', color: NeonTheme.neonCyan),
                    ResponsiveHeading(
                      score.toString(),
                      color: NeonTheme.neonLime,
                    ),
                  ],
                ),
                Column(
                  children: [
                    ResponsiveBody('Safe Tiles', color: NeonTheme.neonCyan),
                    ResponsiveHeading(
                      '$safeTilesClicked/$totalMines',
                      color: NeonTheme.neonLime,
                    ),
                  ],
                ),
                Column(
                  children: [
                    ResponsiveBody('Mines', color: Colors.red),
                    ResponsiveHeading(totalMines.toString(), color: Colors.red),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Game Status
            if (gameStarted)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: gameOver
                        ? Colors.red
                        : gameWon
                        ? NeonTheme.neonLime
                        : NeonTheme.neonCyan,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ResponsiveBody(
                  gameOver && !gameWon
                      ? 'Game Over! Hit a mine! 💥'
                      : gameWon
                      ? 'You Won! All safe tiles revealed! 🎉'
                      : 'Click tiles to reveal them.',
                  color: gameOver && !gameWon
                      ? Colors.red
                      : gameWon
                      ? NeonTheme.neonLime
                      : NeonTheme.neonCyan,
                  textAlign: TextAlign.center,
                ),
              )
            else
              ResponsiveBody(
                'Click a tile to start the game!',
                color: NeonTheme.neonCyan,
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 24),

            // Game Grid
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: NeonTheme.neonCyan, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: GridView.count(
                crossAxisCount: cols,
                shrinkWrap: true,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: List.generate(gridSize, (index) {
                  bool isRevealed = revealed[index];
                  bool isMine = grid[index];

                  return GestureDetector(
                    onTap: () => _revealTile(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: !isRevealed
                            ? NeonTheme.darkBg2
                            : isMine
                            ? Colors.red.withOpacity(0.3)
                            : NeonTheme.neonLime.withOpacity(0.1),
                        border: Border.all(
                          color: !isRevealed
                              ? NeonTheme.neonCyan
                              : isMine
                              ? Colors.red
                              : NeonTheme.neonLime,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: isRevealed
                            ? ResponsiveHeading(
                                isMine ? '💣' : '✓',
                                color: isMine ? Colors.red : NeonTheme.neonLime,
                              )
                            : ResponsiveSubheading(
                                '?',
                                color: NeonTheme.neonCyan.withOpacity(0.5),
                              ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            if (gameStarted && !gameOver && !gameWon)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _cashOut,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NeonTheme.neonLime.withOpacity(0.2),
                      side: BorderSide(color: NeonTheme.neonLime, width: 2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: ResponsiveSubheading(
                      'Cash Out',
                      color: NeonTheme.neonLime,
                    ),
                  ),
                ],
              ),
            if (gameOver || gameWon)
              ElevatedButton(
                onPressed: () => setState(() => _initializeGame()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: NeonTheme.neonCyan.withOpacity(0.2),
                  side: BorderSide(color: NeonTheme.neonCyan, width: 2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: ResponsiveSubheading(
                  'Play Again',
                  color: NeonTheme.neonCyan,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
