import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/core/neon_theme.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';

class SudokuGameScreen extends StatefulWidget {
  const SudokuGameScreen({super.key});

  @override
  State<SudokuGameScreen> createState() => _SudokuGameScreenState();
}

class _SudokuGameScreenState extends State<SudokuGameScreen> {
  late List<List<int>> board;
  late List<List<int>> original;
  late List<List<bool>> editable;
  int? selectedRow;
  int? selectedCol;
  int score = 0;
  bool gameComplete = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    // Simple Sudoku puzzle (0 means empty)
    board = [
      [5, 3, 0, 0, 7, 0, 0, 0, 0],
      [6, 0, 0, 1, 9, 5, 0, 0, 0],
      [0, 9, 8, 0, 0, 0, 0, 6, 0],
      [8, 0, 0, 0, 6, 0, 0, 0, 3],
      [4, 0, 0, 8, 0, 3, 0, 0, 1],
      [7, 0, 0, 0, 2, 0, 0, 0, 6],
      [0, 6, 0, 0, 0, 0, 2, 8, 0],
      [0, 0, 0, 4, 1, 9, 0, 0, 5],
      [0, 0, 0, 0, 8, 0, 0, 7, 9],
    ];

    original = board.map((row) => [...row]).toList();
    editable = [];
    for (int i = 0; i < 9; i++) {
      editable.add([]);
      for (int j = 0; j < 9; j++) {
        editable[i].add(board[i][j] == 0);
      }
    }
  }

  void _setNumber(int number) {
    if (selectedRow != null && selectedCol != null) {
      if (editable[selectedRow!][selectedCol!]) {
        setState(() {
          board[selectedRow!][selectedCol!] = number;
          _checkIfComplete();
        });
      }
    }
  }

  void _checkIfComplete() {
    bool complete = true;
    for (var row in board) {
      for (var cell in row) {
        if (cell == 0) {
          complete = false;
          break;
        }
      }
    }
    if (complete) {
      gameComplete = true;
      score += 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeonTheme.darkBg,
      appBar: AppBar(
        title: const ResponsiveSubheading('Sudoku', color: Colors.white),
        backgroundColor: NeonTheme.darkBg2,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ResponsiveSubheading('Score: $score', color: NeonTheme.neonLime),
            const SizedBox(height: 24),
            // Sudoku Grid
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: NeonTheme.neonCyan, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: List.generate(9, (row) {
                  return Row(
                    children: List.generate(9, (col) {
                      final isSelected =
                          selectedRow == row && selectedCol == col;
                      final isOriginal = !editable[row][col];
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedRow = row;
                              selectedCol = col;
                            });
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? NeonTheme.neonLime
                                    : NeonTheme.neonCyan.withOpacity(0.3),
                                width: isSelected ? 2 : 1,
                              ),
                              color: isSelected
                                  ? NeonTheme.neonLime.withOpacity(0.1)
                                  : isOriginal
                                  ? NeonTheme.neonBlue.withOpacity(0.05)
                                  : NeonTheme.darkBg2,
                            ),
                            child: Center(
                              child: board[row][col] == 0
                                  ? const SizedBox()
                                  : ResponsiveBody(
                                      board[row][col].toString(),
                                      color: isOriginal
                                          ? NeonTheme.neonCyan
                                          : NeonTheme.neonLime,
                                    ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),
            if (gameComplete) ...[
              ResponsiveSubheading('PUZZLE SOLVED!', color: NeonTheme.neonLime),
              const SizedBox(height: 12),
            ],
            // Number buttons
            GridView.count(
              crossAxisCount: 5,
              shrinkWrap: true,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: List.generate(9, (index) {
                return ElevatedButton(
                  onPressed: () => _setNumber(index + 1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NeonTheme.neonCyan.withOpacity(0.2),
                    side: BorderSide(color: NeonTheme.neonCyan),
                  ),
                  child: ResponsiveSubheading(
                    (index + 1).toString(),
                    color: NeonTheme.neonCyan,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
