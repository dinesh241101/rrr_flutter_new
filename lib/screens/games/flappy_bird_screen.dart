import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:rrr_flutter_new/core/neon_theme.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';

class FlappyBirdScreen extends StatefulWidget {
  const FlappyBirdScreen({super.key});

  @override
  State<FlappyBirdScreen> createState() => _FlappyBirdScreenState();
}

class _FlappyBirdScreenState extends State<FlappyBirdScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double birdY = 0.5;
  double velocity = 0;
  double pipeX = 1.0;
  double pipeGapSize = 0.3;
  int score = 0;
  int bestScore = 0;
  bool gameOver = false;
  bool gameStarted = false;
  late Timer gameTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (gameTimer.isActive) {
      gameTimer.cancel();
    }
    super.dispose();
  }

  void _startGame() {
    setState(() {
      gameStarted = true;
      gameOver = false;
      birdY = 0.5;
      velocity = 0;
      pipeX = 1.0;
      score = 0;
    });

    gameTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      _updateGame();
    });
  }

  void _updateGame() {
    setState(() {
      // Apply gravity
      velocity += 0.4;
      birdY += velocity * 0.05;

      // Move pipe
      pipeX -= 0.03;

      // Reset pipe when it goes off screen
      if (pipeX < -0.2) {
        pipeX = 1.0;
        score++;
        // Slightly increase difficulty
        pipeGapSize = max(0.15, pipeGapSize - 0.02);
      }

      // Check collision with ground or ceiling
      if (birdY < 0 || birdY > 1) {
        _endGame();
      }

      // Check collision with pipes
      if (pipeX > 0.15 && pipeX < 0.35) {
        if (birdY < pipeGapSize * 0.5 || birdY > (pipeGapSize * 0.5 + 0.2)) {
          _endGame();
        }
      }
    });
  }

  void _endGame() {
    gameTimer.cancel();
    setState(() {
      gameOver = true;
      if (score > bestScore) {
        bestScore = score;
      }
    });
  }

  void _jump() {
    if (!gameStarted) {
      _startGame();
    }
    if (!gameOver) {
      setState(() {
        velocity = -8;
      });
    }
  }

  void _resetGame() {
    setState(() {
      gameStarted = false;
      gameOver = false;
      birdY = 0.5;
      velocity = 0;
      pipeX = 1.0;
      score = 0;
      pipeGapSize = 0.3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeonTheme.darkBg,
      appBar: AppBar(
        title: const ResponsiveSubheading('Flappy Bird', color: Colors.white),
        backgroundColor: NeonTheme.darkBg2,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Score Display
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
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
          ),
          // Game Area
          Expanded(
            child: GestureDetector(
              onTap: _jump,
              child: Container(
                decoration: BoxDecoration(
                  color: NeonTheme.darkBg2,
                  border: Border.all(color: NeonTheme.neonCyan, width: 2),
                ),
                child: Stack(
                  children: [
                    // Bird
                    Positioned(
                      left: 30,
                      top: birdY * 500,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: NeonTheme.neonLime,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: NeonTheme.neonLime.withOpacity(0.6),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(child: ResponsiveCaption('🐦')),
                      ),
                    ),
                    // Top Pipe
                    Positioned(
                      left: MediaQuery.of(context).size.width * pipeX,
                      top: 0,
                      child: Container(
                        width: 60,
                        height: (pipeGapSize * 0.5) * 500,
                        decoration: BoxDecoration(
                          color: NeonTheme.neonCyan,
                          border: Border.all(
                            color: NeonTheme.neonLime,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: NeonTheme.neonCyan.withOpacity(0.5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Bottom Pipe
                    Positioned(
                      left: MediaQuery.of(context).size.width * pipeX,
                      top: ((pipeGapSize * 0.5) + 0.2) * 500,
                      child: Container(
                        width: 60,
                        height: (1 - (pipeGapSize * 0.5 + 0.2)) * 500,
                        decoration: BoxDecoration(
                          color: NeonTheme.neonCyan,
                          border: Border.all(
                            color: NeonTheme.neonLime,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: NeonTheme.neonCyan.withOpacity(0.5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Game Over Screen
                    if (gameOver)
                      Container(
                        color: Colors.black.withOpacity(0.7),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ResponsiveHeading(
                                'Game Over!',
                                color: NeonTheme.neonLime,
                              ),
                              const SizedBox(height: 16),
                              ResponsiveSubheading(
                                'Score: $score',
                                color: NeonTheme.neonCyan,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _resetGame,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: NeonTheme.neonCyan
                                      .withOpacity(0.2),
                                  side: BorderSide(
                                    color: NeonTheme.neonCyan,
                                    width: 2,
                                  ),
                                ),
                                child: ResponsiveSubheading(
                                  'Try Again',
                                  color: NeonTheme.neonCyan,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Start Prompt
                    if (!gameStarted && !gameOver)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ResponsiveHeading(
                                'Tap to Start',
                                color: NeonTheme.neonLime,
                              ),
                              const SizedBox(height: 16),
                              ResponsiveBody(
                                'Tap or click to make the bird fly',
                                color: NeonTheme.neonCyan,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
