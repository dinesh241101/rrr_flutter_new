import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/core/neon_theme.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';
import 'dart:async';
import 'dart:math';

class SnakeGameScreen extends StatefulWidget {
  const SnakeGameScreen({super.key});

  @override
  State<SnakeGameScreen> createState() => _SnakeGameScreenState();
}

class _SnakeGameScreenState extends State<SnakeGameScreen>
    with TickerProviderStateMixin {
  late Timer gameTimer;
  List<Offset> snakeBody = [const Offset(10, 10)];
  late Offset food;
  Offset direction = const Offset(1, 0);
  Offset nextDirection = const Offset(1, 0);
  int score = 0;
  bool gameOver = false;
  bool gamePaused = false;

  @override
  void initState() {
    super.initState();
    food = Offset(
      Random().nextInt(20).toDouble(),
      Random().nextInt(20).toDouble(),
    );
    _startGame();
  }

  void _startGame() {
    gameTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!gamePaused && !gameOver) {
        setState(() {
          direction = nextDirection;
          Offset head = snakeBody.last;
          Offset newHead = Offset(
            (head.dx + direction.dx) % 20,
            (head.dy + direction.dy) % 20,
          );

          if (snakeBody.contains(newHead)) {
            gameOver = true;
            return;
          }

          snakeBody.add(newHead);

          if (newHead == food) {
            score += 10;
            food = Offset(
              Random().nextInt(20).toDouble(),
              Random().nextInt(20).toDouble(),
            );
          } else {
            snakeBody.removeAt(0);
          }
        });
      }
    });
  }

  void _changeDirection(Offset newDirection) {
    if ((direction.dx + newDirection.dx).abs() == 1 &&
        (direction.dy + newDirection.dy).abs() == 1) {
      return;
    }
    if ((direction.dx + newDirection.dx) == 0 &&
        (direction.dy + newDirection.dy) == 0) {
      return;
    }
    nextDirection = newDirection;
  }

  @override
  void dispose() {
    gameTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeonTheme.darkBg,
      appBar: AppBar(
        title: const ResponsiveSubheading('Snake Game', color: Colors.white),
        backgroundColor: NeonTheme.darkBg2,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          ResponsiveSubheading('Score: $score', color: NeonTheme.neonLime),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTapUp: (details) {
                  final width = MediaQuery.of(context).size.width;
                  if (details.globalPosition.dx < width / 2) {
                    _changeDirection(const Offset(-1, 0));
                  } else {
                    _changeDirection(const Offset(1, 0));
                  }
                },
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0) {
                    _changeDirection(const Offset(0, 1));
                  } else {
                    _changeDirection(const Offset(0, -1));
                  }
                },
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: NeonTheme.neonCyan, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomPaint(
                    painter: SnakePainter(snakeBody: snakeBody, food: food),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (gameOver) ...[
            ResponsiveSubheading('GAME OVER', color: Colors.red),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  snakeBody = [const Offset(10, 10)];
                  food = Offset(
                    Random().nextInt(20).toDouble(),
                    Random().nextInt(20).toDouble(),
                  );
                  direction = const Offset(1, 0);
                  nextDirection = const Offset(1, 0);
                  score = 0;
                  gameOver = false;
                });
                gameTimer.cancel();
                _startGame();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: NeonTheme.neonLime,
              ),
              child: const ResponsiveBody('Restart'),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class SnakePainter extends CustomPainter {
  final List<Offset> snakeBody;
  final Offset food;

  SnakePainter({required this.snakeBody, required this.food});

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / 20;
    final snakePaint = Paint()..color = NeonTheme.neonLime;
    final foodPaint = Paint()..color = NeonTheme.neonPink;
    final headPaint = Paint()..color = NeonTheme.neonCyan;

    for (int i = 0; i < snakeBody.length; i++) {
      final offset = snakeBody[i];
      final rect = Rect.fromLTWH(
        offset.dx * cellSize + 2,
        offset.dy * cellSize + 2,
        cellSize - 4,
        cellSize - 4,
      );
      if (i == snakeBody.length - 1) {
        canvas.drawRect(rect, headPaint);
      } else {
        canvas.drawRect(rect, snakePaint);
      }
    }

    canvas.drawCircle(
      Offset(
        food.dx * cellSize + cellSize / 2,
        food.dy * cellSize + cellSize / 2,
      ),
      cellSize / 2 - 2,
      foodPaint,
    );
  }

  @override
  bool shouldRepaint(SnakePainter oldDelegate) => true;
}
