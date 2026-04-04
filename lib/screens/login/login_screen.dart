import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/core/constants/app_assets.dart';
import 'package:rrr_flutter_new/core/constants/app_strings.dart';
import 'package:rrr_flutter_new/screens/app_shell.dart';
import 'package:rrr_flutter_new/screens/rrr_intro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  bool hidePassword = true;
  bool loading = false;

  late AnimationController particleController;
  List<_Particle> particles = List.generate(35, (_) => _Particle());

  @override
  void initState() {
    super.initState();
    particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    particleController.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate() || loading) return;

    setState(() => loading = true);

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AppShell()),
    );
  }

  void _guest() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RRRIntroScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🌌 BACKGROUND
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF050816), Color(0xFF0B1F3A)],
              ),
            ),
          ),

          /// ✨ PARTICLES
          AnimatedBuilder(
            animation: particleController,
            builder: (_, _) {
              return CustomPaint(
                painter: _ParticlePainter(particles),
                size: Size.infinite,
              );
            },
          ),

          /// UI
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.6),
                  border: Border.all(color: Colors.white12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.3),
                      blurRadius: 25,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      /// LOGO
                      Container(
                        width: 90,
                        height: 90,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.blueAccent),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.6),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Image.asset(AppAssets.appLogo),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        AppStrings.appName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      _input(email, "Email", Icons.email),
                      const SizedBox(height: 12),
                      _input(password, "Password", Icons.lock, true),

                      const SizedBox(height: 20),

                      /// LOGIN
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text("LOGIN"),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// GUEST BUTTON
                      TextButton(
                        onPressed: _guest,
                        child: const Text(
                          "Continue as Guest",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(
    TextEditingController c,
    String hint,
    IconData icon, [
    bool pass = false,
  ]) {
    return TextFormField(
      controller: c,
      obscureText: pass ? hidePassword : false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        suffixIcon: pass
            ? IconButton(
                icon: Icon(
                  hidePassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() => hidePassword = !hidePassword);
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
    );
  }
}

/// PARTICLES
class _Particle {
  double x = Random().nextDouble();
  double y = Random().nextDouble();
  double speed = Random().nextDouble() * 0.002 + 0.001;

  void update() {
    y -= speed;
    if (y < 0) {
      y = 1;
      x = Random().nextDouble();
    }
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var p in particles) {
      p.update();
      paint.color = Colors.blueAccent.withOpacity(0.6);
      canvas.drawCircle(Offset(p.x * size.width, p.y * size.height), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
