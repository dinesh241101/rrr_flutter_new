import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rrr_flutter_new/core/constants/app_assets.dart';
import 'package:rrr_flutter_new/core/constants/app_strings.dart';
import 'package:rrr_flutter_new/core/neon_theme.dart';
import 'package:rrr_flutter_new/screens/app_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String _lastShownKey = "login_last_shown";

  /// 🔥 CHECK IF LOGIN SHOULD SHOW
  static Future<bool> shouldShowLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getInt(_lastShownKey);

    if (last == null) return true;

    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - last) > 24 * 60 * 60 * 1000;
  }

  static Future<void> markShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastShownKey, DateTime.now().millisecondsSinceEpoch);
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  bool hidePassword = true;
  bool loading = false;
  bool isSignUp = false;

  late AnimationController particleController;
  List<_Star> stars = List.generate(40, (_) => _Star());

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
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate() || loading) return;

    setState(() => loading = true);

    try {
      final supabase = Supabase.instance.client;

      final email = emailController.text.isNotEmpty
          ? emailController.text.trim()
          : "${mobileController.text}@rrr.app";

      final password = passwordController.text;

      if (isSignUp) {
        /// 🔥 SIGNUP → MOBILE REQUIRED
        if (mobileController.text.isEmpty) {
          throw "Mobile number is required";
        }

        await supabase.auth.signUp(
          email: email,
          password: password,
          data: {
            'username': nameController.text,
            'mobile_number': mobileController.text,
          },
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Signup success. Please login")),
        );

        setState(() => isSignUp = false);
      } else {
        /// LOGIN
        await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );

        await LoginScreen.markShown();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AppShell()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    } finally {
      setState(() => loading = false);
    }
  }

  void _guest() async {
    await LoginScreen.markShown();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AppShell()),
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
                colors: [NeonTheme.darkBg, NeonTheme.darkBg2],
              ),
            ),
          ),

          /// ⭐ FALLING STARS
          AnimatedBuilder(
            animation: particleController,
            builder: (_, __) {
              return CustomPaint(
                painter: _StarPainter(stars),
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
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: NeonTheme.darkCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: NeonTheme.neonCyan),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      /// LOGO
                      Image.asset(AppAssets.appLogo, height: 80),

                      const SizedBox(height: 20),

                      Text(
                        isSignUp ? "Create Account" : "Welcome Back",
                        style: const TextStyle(color: Colors.white),
                      ),

                      const SizedBox(height: 20),

                      /// NAME
                      if (isSignUp) _input(nameController, "Name"),

                      /// MOBILE (MANDATORY FOR SIGNUP)
                      _input(mobileController, "Mobile Number"),

                      /// EMAIL (OPTIONAL)
                      if (isSignUp) _input(emailController, "Email (Optional)"),

                      /// PASSWORD
                      _input(passwordController, "Password", isPassword: true),

                      const SizedBox(height: 20),

                      /// BUTTON
                      ElevatedButton(
                        onPressed: _handleAuth,
                        child: loading
                            ? const CircularProgressIndicator()
                            : Text(isSignUp ? "SIGN UP" : "LOGIN"),
                      ),

                      const SizedBox(height: 10),

                      TextButton(
                        onPressed: () {
                          setState(() => isSignUp = !isSignUp);
                        },
                        child: Text(
                          isSignUp ? "Login" : "Create Account",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),

                      /// GUEST
                      TextButton(
                        onPressed: _guest,
                        child: const Text(
                          "Continue as Guest",
                          style: TextStyle(color: Colors.blueAccent),
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
    String hint, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        obscureText: isPassword ? hidePassword : false,
        decoration: InputDecoration(hintText: hint),
        validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
      ),
    );
  }
}

/// ⭐ STAR PARTICLES
class _Star {
  double x = Random().nextDouble();
  double y = Random().nextDouble();
  double speed = Random().nextDouble() * 0.005 + 0.002;

  void update() {
    y += speed;
    if (y > 1) {
      y = 0;
      x = Random().nextDouble();
    }
  }
}

class _StarPainter extends CustomPainter {
  final List<_Star> stars;

  _StarPainter(this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var s in stars) {
      s.update();
      paint.color = Colors.blueAccent.withOpacity(0.6);
      canvas.drawCircle(
        Offset(s.x * size.width, s.y * size.height),
        1.5,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
