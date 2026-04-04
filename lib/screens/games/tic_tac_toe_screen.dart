import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/core/neon_theme.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  late List<String> board;
  bool isXNext = true;
  bool gameOver = false;
  String? winner;
  int xScore = 0;
  int oScore = 0;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    board = List.filled(9, '');
    isXNext = true;
    gameOver = false;
    winner = null;
  }

  void _makeMove(int index) {
    if (board[index].isEmpty && !gameOver) {
      setState(() {
        board[index] = isXNext ? 'X' : 'O';
        isXNext = !isXNext;
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    const winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]].isNotEmpty &&
          board[pattern[0]] == board[pattern[1]] &&
          board[pattern[1]] == board[pattern[2]]) {
        winner = board[pattern[0]];
        gameOver = true;
        if (winner == 'X') {
          xScore++;
        } else {
          oScore++;
        }
        return;
      }
    }

    if (board.every((cell) => cell.isNotEmpty)) {
      gameOver = true;
    }
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeonTheme.darkBg,
      appBar: AppBar(
        title: const ResponsiveSubheading('Tic Tac Toe', color: Colors.white),
        backgroundColor: NeonTheme.darkBg2,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Scoreboard
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ResponsiveBody('Player X', color: NeonTheme.neonLime),
                    const SizedBox(height: 8),
                    ResponsiveHeading(
                      xScore.toString(),
                      color: NeonTheme.neonLime,
                    ),
                  ],
                ),
                Column(
                  children: [
                    ResponsiveBody('Player O', color: NeonTheme.neonCyan),
                    const SizedBox(height: 8),
                    ResponsiveHeading(
                      oScore.toString(),
                      color: NeonTheme.neonCyan,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Game Status
            if (gameOver && winner != null)
              ResponsiveSubheading(
                'Player $winner Wins! 🎉',
                color: NeonTheme.neonLime,
              )
            else if (gameOver)
              const ResponsiveSubheading("It's a Draw!", color: Colors.yellow)
            else
              ResponsiveBody(
                'Current Player: ${isXNext ? "X" : "O"}',
                color: isXNext ? NeonTheme.neonLime : NeonTheme.neonCyan,
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
                crossAxisCount: 3,
                shrinkWrap: true,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: List.generate(9, (index) {
                  return GestureDetector(
                    onTap: () => _makeMove(index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: NeonTheme.neonCyan, width: 2),
                        color: NeonTheme.darkBg2,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: ResponsiveHeading(
                          board[index],
                          color: board[index] == 'X'
                              ? NeonTheme.neonLime
                              : NeonTheme.neonCyan,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 32),

            // New Game Button
            ElevatedButton(
              onPressed: _resetGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: NeonTheme.neonCyan.withOpacity(0.2),
                side: BorderSide(color: NeonTheme.neonCyan, width: 2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: ResponsiveSubheading(
                'New Game',
                color: NeonTheme.neonCyan,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
