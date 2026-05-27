import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/core/theme/app_theme.dart';
import 'package:rrr_flutter_new/screens/app_shell.dart';
import 'package:rrr_flutter_new/screens/rrr_intro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _usernameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isSignUpMode = false;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _loading = false;

  late AnimationController _particleController;
  final List<_Particle> _particles = List.generate(40, (_) => _Particle());

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _particleController.dispose();
    _usernameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_isSignUpMode && !_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Terms & Conditions')),
      );
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => _loading = false);

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
          // Background Glow
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xFF0F122B), Color(0xFF060714)],
                radius: 1.5,
              ),
            ),
          ),

          // Particle Layer
          AnimatedBuilder(
            animation: _particleController,
            builder: (_, _) {
              return CustomPaint(
                painter: _ParticlePainter(_particles),
                size: Size.infinite,
              );
            },
          ),

          // Login/Signup form content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Hexagon glowing profile logo
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.08),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.4), width: 1.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryColor.withOpacity(0.2),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.person_outline_rounded,
                                  color: AppTheme.primaryColor,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Form Headers
                        Text(
                          _isSignUpMode ? 'Create Account' : 'Welcome Back!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _isSignUpMode
                              ? 'Sign up and start winning coins!'
                              : 'Login to continue',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Form Fields
                        if (_isSignUpMode) ...[
                          _buildInput(
                            controller: _usernameController,
                            hint: 'Username',
                            icon: Icons.person_outline_rounded,
                            validator: (val) => (val == null || val.isEmpty) ? 'Enter a username' : null,
                          ),
                          const SizedBox(height: 14),
                        ],

                        _buildInput(
                          controller: _mobileController,
                          hint: 'Mobile Number',
                          icon: Icons.phone_android_rounded,
                          keyboardType: TextInputType.phone,
                          prefix: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              '+91',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Enter mobile number';
                            if (val.length < 10) return 'Enter a valid mobile number';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        _buildInput(
                          controller: _passwordController,
                          hint: 'Password',
                          icon: Icons.lock_outline_rounded,
                          isPassword: true,
                          hidePassword: _hidePassword,
                          togglePasswordVisibility: () => setState(() => _hidePassword = !_hidePassword),
                          validator: (val) => (val == null || val.length < 6) ? 'Password must be 6+ chars' : null,
                        ),
                        const SizedBox(height: 14),

                        if (_isSignUpMode) ...[
                          _buildInput(
                            controller: _confirmPasswordController,
                            hint: 'Confirm Password',
                            icon: Icons.lock_outline_rounded,
                            isPassword: true,
                            hidePassword: _hideConfirmPassword,
                            togglePasswordVisibility: () =>
                                setState(() => _hideConfirmPassword = !_hideConfirmPassword),
                            validator: (val) {
                              if (val != _passwordController.text) return 'Passwords do not match';
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          // Terms & Conditions Checkbox
                          Row(
                            children: [
                              Checkbox(
                                value: _agreeToTerms,
                                activeColor: AppTheme.primaryColor,
                                onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
                              ),
                              const Expanded(
                                child: Text(
                                  'I agree to the Terms & Conditions',
                                  style: TextStyle(color: Colors.white70, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          // Forgot Password aligned to the right
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Password reset link sent!')),
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(color: Colors.blueAccent, fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),

                        // Main Submit Button
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: _loading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    _isSignUpMode ? 'Sign Up' : 'Login',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        // Login Screen Social Options or Guest option
                        if (!_isSignUpMode) ...[
                          const SizedBox(height: 16),
                          const Center(
                            child: Text(
                              'or',
                              style: TextStyle(color: Colors.white54, fontSize: 14),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Continue as Guest
                          SizedBox(
                            height: 52,
                            child: OutlinedButton(
                              onPressed: _guest,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white24, width: 1.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Continue as Guest',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),

                        // Footer Toggle Text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isSignUpMode ? 'Already have an account? ' : "Don't have an account? ",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            GestureDetector(
                              onTap: () => setState(() {
                                _isSignUpMode = !_isSignUpMode;
                                _formKey.currentState?.reset();
                              }),
                              child: Text(
                                _isSignUpMode ? 'Login' : 'Sign Up',
                                style: const TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool hidePassword = false,
    VoidCallback? togglePasswordVisibility,
    Widget? prefix,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? hidePassword : false,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: prefix != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: Icon(icon, color: Colors.white38, size: 20),
                  ),
                  prefix,
                ],
              )
            : Icon(icon, color: Colors.white38, size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  hidePassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white38,
                  size: 20,
                ),
                onPressed: togglePasswordVisibility,
              )
            : null,
        filled: true,
        fillColor: AppTheme.cardColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white10, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
        ),
      ),
      validator: validator,
    );
  }
}

// Particle Engine
class _Particle {
  double x = Random().nextDouble();
  double y = Random().nextDouble();
  double speed = Random().nextDouble() * 0.0015 + 0.0005;
  double size = Random().nextDouble() * 2 + 1;
  double opacity = Random().nextDouble() * 0.5 + 0.2;

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
      paint.color = AppTheme.primaryColor.withOpacity(p.opacity);
      canvas.drawCircle(Offset(p.x * size.width, p.y * size.height), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
