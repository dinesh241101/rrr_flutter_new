import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/core/constants/app_assets.dart';
import 'package:rrr_flutter_new/screens/home/home_screen.dart';
import 'package:rrr_flutter_new/screens/login/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  Timer? _progressTimer;
  Timer? _titleTimer;
  Timer? _messageTimer;
  Timer? _navigationTimer;

  double progress = 0;

  final List<String> titles = [
    "Run-Reward-Rift",
    "Quizistan",
    "Play & Earn",
    "And Many More!",
  ];

  final List<String> messages = [
    "Initializing",
    "Loading neon glow",
    "Spawning particles",
    "Syncing systems",
    "Almost ready",
  ];

  int titleIndex = 0;
  int messageIndex = 0;

  late List<Particle> particles;

  @override
  void initState() {
    super.initState();

    /// Controllers (smooth animation)
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    particles = List.generate(40, (_) => Particle());

    _startLogic();
  }

  void _startLogic() {
    /// Progress (smooth)
    _progressTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (progress >= 1) {
        timer.cancel();
        _goNext();
      } else {
        setState(() {
          progress = min(progress + 0.008, 1);
        });
      }
    });

    /// Title switch
    _titleTimer = Timer.periodic(const Duration(milliseconds: 900), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        titleIndex = (titleIndex + 1) % titles.length;
      });
    });

    /// Message switch
    _messageTimer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        messageIndex = (messageIndex + 1) % messages.length;
      });
    });
  }

  void _goNext() {
    if (_navigationTimer?.isActive ?? false) {
      return;
    }
    _navigationTimer = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      _stopTimers();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  void _stopTimers() {
    _progressTimer?.cancel();
    _titleTimer?.cancel();
    _messageTimer?.cancel();
    _navigationTimer?.cancel();
  }

  @override
  void dispose() {
    _stopTimers();
    _rotationController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xFF0F1923), Color(0xFF050A14)],
                radius: 1.2,
              ),
            ),
          ),

          /// 🔥 PARTICLE LAYER (ULTRA SMOOTH)
          AnimatedBuilder(
            animation: _particleController,
            builder: (_, _) {
              return CustomPaint(
                painter: ParticlePainter(particles),
                size: Size.infinite,
              );
            },
          ),

          /// MAIN UI
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// LOGO + ROTATION
                Stack(
                  alignment: Alignment.center,
                  children: [
                    RotationTransition(
                      turns: _rotationController,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.purpleAccent.withOpacity(0.5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purpleAccent.withOpacity(0.6),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: ScaleTransition(
                        scale: Tween(
                          begin: 1.0,
                          end: 1.05,
                        ).animate(_pulseController),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Image.asset(
                            AppAssets.appLogo,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.sports_esports,
                              size: 50,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// TITLE
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    titles[titleIndex],
                    key: ValueKey(titleIndex),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// MESSAGE
                Text(
                  "${messages[messageIndex]}...",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),

                const SizedBox(height: 30),

                /// PROGRESS BAR
                Container(
                  width: 260,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        width: 260 * progress,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [Colors.blueAccent, Colors.purpleAccent],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  "${(progress * 100).toInt()}%",
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= PARTICLE ENGINE =================

class Particle {
  double x = Random().nextDouble();
  double y = Random().nextDouble();
  double size = Random().nextDouble() * 3 + 1;
  double speed = Random().nextDouble() * 0.002 + 0.0005;
  double opacity = Random().nextDouble();

  void update() {
    y -= speed;
    if (y < 0) {
      y = 1;
      x = Random().nextDouble();
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blueAccent;

    for (var p in particles) {
      p.update();

      paint.color = Colors.blueAccent.withOpacity(p.opacity);

      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
