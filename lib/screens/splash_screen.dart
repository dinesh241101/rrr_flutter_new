import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/core/constants/app_strings.dart';
import 'package:rrr_flutter_new/core/constants/app_values.dart';
import 'package:rrr_flutter_new/screens/app_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnim = Tween<double>(begin: 0.6, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _glowAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    _goToHome();
  }

  Future<void> _goToHome() async {
    await Future<void>.delayed(
      const Duration(milliseconds: AppValues.splashDurationMs),
    );
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const AppShell()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F4C81), Color(0xFF0A2C49)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// 🎮 LOGO (Animated Scale + Glow)
                  Transform.scale(
                    scale: _scaleAnim.value,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(_glowAnim.value * 0.6),
                            blurRadius: 40 * _glowAnim.value,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.sports_esports,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ✨ TEXT (Fade + Slight Scale)
                  Opacity(
                    opacity: _fadeAnim.value,
                    child: Transform.scale(
                      scale: 0.9 + (_fadeAnim.value * 0.1),
                      child: const Text(
                        AppStrings.appName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// 🔥 LIGHT SWEEP BAR (Netflix vibe)
                  Opacity(
                    opacity: _fadeAnim.value,
                    child: Container(
                      width: 160,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.blueAccent,
                            Colors.white,
                            Colors.blueAccent,
                            Colors.transparent,
                          ],
                          stops: [
                            0.0,
                            _controller.value.clamp(0.2, 0.4),
                            _controller.value.clamp(0.4, 0.6),
                            _controller.value.clamp(0.6, 0.8),
                            1.0,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}