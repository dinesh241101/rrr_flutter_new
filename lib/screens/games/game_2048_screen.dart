import 'package:flutter/material.dart';
import 'dart:math';
import 'package:rrr_flutter_new/core/neon_theme.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';

class Game2048Screen extends StatefulWidget {
  const Game2048Screen({super.key});

  @override
  State<Game2048Screen> createState() => _Game2048ScreenState();
}

class _Game2048ScreenState extends State<Game2048Screen> {
  late List<List<int>> board;
  int score = 0;
  int bestScore = 0;
  bool gameOver = false;
  bool gameWon = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    board = List.generate(4, (_) => List.filled(4, 0));
    score = 0;
    gameOver = false;
    gameWon = false;
    _addNewTile();
    _addNewTile();
  }

  void _addNewTile() {
    List<(int, int)> emptyTiles = [];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board[i][j] == 0) {
          emptyTiles.add((i, j));
        }
      }
    }

    if (emptyTiles.isNotEmpty) {
      var (row, col) = emptyTiles[Random().nextInt(emptyTiles.length)];
      board[row][col] = Random().nextBool() ? 2 : 4;
    }
  }

  void _moveLeft() {
    bool moved = false;
    for (int i = 0; i < 4; i++) {
      List<int> row = board[i];
      List<int> newRow = [];

      for (int j = 0; j < 4; j++) {
        if (row[j] != 0) {
          newRow.add(row[j]);
        }
      }

      while (newRow.length < 4) {
        newRow.add(0);
      }

      for (int j = 0; j < 3; j++) {
        if (newRow[j] == newRow[j + 1] && newRow[j] != 0) {
          newRow[j] *= 2;
          score += newRow[j];
          if (newRow[j] == 2048) {
            gameWon = true;
          }
          newRow.removeAt(j + 1);
          newRow.add(0);
        }
      }

      if (row != newRow) {
        moved = true;
        board[i] = newRow;
      }
    }

    if (moved) {
      _addNewTile();
      _checkGameOver();
      setState(() {});
    }
  }

  void _moveRight() {
    bool moved = false;
    for (int i = 0; i < 4; i++) {
      List<int> row = board[i].reversed.toList();
      List<int> newRow = [];

      for (int j = 0; j < 4; j++) {
        if (row[j] != 0) {
          newRow.add(row[j]);
        }
      }

      while (newRow.length < 4) {
        newRow.add(0);
      }

      for (int j = 0; j < 3; j++) {
        if (newRow[j] == newRow[j + 1] && newRow[j] != 0) {
          newRow[j] *= 2;
          score += newRow[j];
          if (newRow[j] == 2048) {
            gameWon = true;
          }
          newRow.removeAt(j + 1);
          newRow.add(0);
        }
      }

      if (row != newRow) {
        moved = true;
        board[i] = newRow.reversed.toList();
      }
    }

    if (moved) {
      _addNewTile();
      _checkGameOver();
      setState(() {});
    }
  }

  void _moveUp() {
    bool moved = false;
    for (int j = 0; j < 4; j++) {
      List<int> col = [];
      for (int i = 0; i < 4; i++) {
        if (board[i][j] != 0) {
          col.add(board[i][j]);
        }
      }

      while (col.length < 4) {
        col.add(0);
      }

      for (int i = 0; i < 3; i++) {
        if (col[i] == col[i + 1] && col[i] != 0) {
          col[i] *= 2;
          score += col[i];
          if (col[i] == 2048) {
            gameWon = true;
          }
          col.removeAt(i + 1);
          col.add(0);
        }
      }

      for (int i = 0; i < 4; i++) {
        if (board[i][j] != col[i]) {
          moved = true;
          board[i][j] = col[i];
        }
      }
    }

    if (moved) {
      _addNewTile();
      _checkGameOver();
      setState(() {});
    }
  }

  void _moveDown() {
    bool moved = false;
    for (int j = 0; j < 4; j++) {
      List<int> col = [];
      for (int i = 3; i >= 0; i--) {
        if (board[i][j] != 0) {
          col.add(board[i][j]);
        }
      }

      while (col.length < 4) {
        col.add(0);
      }

      for (int i = 0; i < 3; i++) {
        if (col[i] == col[i + 1] && col[i] != 0) {
          col[i] *= 2;
          score += col[i];
          if (col[i] == 2048) {
            gameWon = true;
          }
          col.removeAt(i + 1);
          col.add(0);
        }
      }

      for (int i = 0; i < 4; i++) {
        if (board[3 - i][j] != col[i]) {
          moved = true;
          board[3 - i][j] = col[i];
        }
      }
    }

    if (moved) {
      _addNewTile();
      _checkGameOver();
      setState(() {});
    }
  }

  void _checkGameOver() {
    bool hasEmpty = false;
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board[i][j] == 0) {
          hasEmpty = true;
        }
      }
    }

    if (!hasEmpty) {
      gameOver = true;
      if (score > bestScore) {
        bestScore = score;
      }
    }
  }

  Color _getTileColor(int value) {
    switch (value) {
      case 2:
        return NeonTheme.neonCyan.withOpacity(0.3);
      case 4:
        return NeonTheme.neonCyan.withOpacity(0.5);
      case 8:
        return NeonTheme.neonLime.withOpacity(0.3);
      case 16:
        return NeonTheme.neonLime.withOpacity(0.5);
      case 32:
        return NeonTheme.neonMagenta.withOpacity(0.3);
      case 64:
        return NeonTheme.neonMagenta.withOpacity(0.5);
      case 128:
      case 256:
        return Colors.orange.withOpacity(0.4);
      case 512:
      case 1024:
        return Colors.red.withOpacity(0.3);
      case 2048:
        return NeonTheme.neonLime.withOpacity(0.7);
      default:
        return NeonTheme.darkBg2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeonTheme.darkBg,
      appBar: AppBar(
        title: const ResponsiveSubheading('2048', color: Colors.white),
        backgroundColor: NeonTheme.darkBg2,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Score Display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    ResponsiveBody('Best', color: NeonTheme.neonCyan),
                    ResponsiveHeading(
                      bestScore.toString(),
                      color: NeonTheme.neonLime,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Game Board
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: NeonTheme.neonCyan, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: List.generate(16, (index) {
                  int row = index ~/ 4;
                  int col = index % 4;
                  int value = board[row][col];

                  return Container(
                    decoration: BoxDecoration(
                      color: _getTileColor(value),
                      border: Border.all(
                        color: value == 0
                            ? NeonTheme.neonCyan.withOpacity(0.2)
                            : NeonTheme.neonCyan,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: value == 0
                          ? const SizedBox()
                          : ResponsiveSubheading(
                              value.toString(),
                              color: value >= 512
                                  ? Colors.white
                                  : NeonTheme.neonLime,
                            ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),

            // Status Messages
            if (gameWon)
              ResponsiveSubheading(
                'You reached 2048! 🎉',
                color: NeonTheme.neonLime,
              ),
            if (gameOver && !gameWon)
              ResponsiveSubheading('Game Over!', color: Colors.red),
            const SizedBox(height: 24),

            // Control Buttons
            Column(
              children: [
                // Up Button
                ElevatedButton(
                  onPressed: _moveUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NeonTheme.neonCyan.withOpacity(0.2),
                    side: BorderSide(color: NeonTheme.neonCyan),
                  ),
                  child: const Icon(Icons.arrow_upward),
                ),
                const SizedBox(height: 12),
                // Left, Right Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _moveLeft,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NeonTheme.neonCyan.withOpacity(0.2),
                        side: BorderSide(color: NeonTheme.neonCyan),
                      ),
                      child: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _moveRight,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NeonTheme.neonCyan.withOpacity(0.2),
                        side: BorderSide(color: NeonTheme.neonCyan),
                      ),
                      child: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Down Button
                ElevatedButton(
                  onPressed: _moveDown,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NeonTheme.neonCyan.withOpacity(0.2),
                    side: BorderSide(color: NeonTheme.neonCyan),
                  ),
                  child: const Icon(Icons.arrow_downward),
                ),
                const SizedBox(height: 24),
                // New Game Button
                ElevatedButton(
                  onPressed: () => setState(() => _initializeGame()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NeonTheme.neonLime.withOpacity(0.2),
                    side: BorderSide(color: NeonTheme.neonLime, width: 2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: ResponsiveSubheading(
                    'New Game',
                    color: NeonTheme.neonLime,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
