import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'package:rrr_flutter_new/screens/app_shell.dart';

class RRRIntroScreen extends StatefulWidget {
  const RRRIntroScreen({super.key});

  @override
  State<RRRIntroScreen> createState() => _RRRIntroScreenState();
}

class _RRRIntroScreenState extends State<RRRIntroScreen>
    with TickerProviderStateMixin {
  late AnimationController _streakController;
  late AnimationController _textController;
  late AnimationController _burstController;

  List<_BurstParticle> particles = List.generate(50, (_) => _BurstParticle());

  @override
  void initState() {
    super.initState();

    _streakController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _burstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    /// 📳 HAPTIC
    HapticFeedback.heavyImpact();
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 120);
    }

    /// WAIT → TEXT
    await Future.delayed(const Duration(milliseconds: 700));
    _textController.forward();

    /// FIRE BURST
    await Future.delayed(const Duration(milliseconds: 200));
    _burstController.forward();

    /// EXIT
    await Future.delayed(const Duration(milliseconds: 1600));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AppShell()),
    );
  }

  @override
  void dispose() {
    _streakController.dispose();
    _textController.dispose();
    _burstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// 🌌 BACKGROUND GLOW
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xFF0B1F3A), Colors.black],
                radius: 1.2,
              ),
            ),
          ),

          /// ⚡ LIGHT STREAK
          AnimatedBuilder(
            animation: _streakController,
            builder: (_, _) {
              return CustomPaint(
                painter: _StreakPainter(_streakController.value),
                size: Size.infinite,
              );
            },
          ),

          /// 🔥 BURST PARTICLES
          AnimatedBuilder(
            animation: _burstController,
            builder: (_, _) {
              return CustomPaint(
                painter: _BurstPainter(particles, _burstController.value),
                size: Size.infinite,
              );
            },
          ),

          /// 💎 RRR TEXT
          Center(
            child: FadeTransition(
              opacity: _textController,
              child: ScaleTransition(
                scale: Tween(begin: 0.7, end: 1.2).animate(
                  CurvedAnimation(
                    parent: _textController,
                    curve: Curves.easeOutBack,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.9),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Text(
                    "RRR",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 10,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= LIGHT STREAK =================

class _StreakPainter extends CustomPainter {
  final double progress;

  _StreakPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          Colors.blueAccent.withOpacity(0.8),
          Colors.white,
          Colors.blueAccent.withOpacity(0.8),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final x = size.width * progress;

    canvas.drawRect(Rect.fromLTWH(x - 80, 0, 160, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// ================= FIRE BURST =================

class _BurstParticle {
  double angle = Random().nextDouble() * 2 * pi;
  double speed = Random().nextDouble() * 4 + 2;
  double size = Random().nextDouble() * 3 + 2;
}

class _BurstPainter extends CustomPainter {
  final List<_BurstParticle> particles;
  final double progress;

  _BurstPainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint();

    for (var p in particles) {
      final distance = progress * 120 * p.speed;

      final dx = cos(p.angle) * distance;
      final dy = sin(p.angle) * distance;

      paint.color = Colors.blueAccent.withOpacity(1 - progress);

      canvas.drawCircle(center + Offset(dx, dy), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
