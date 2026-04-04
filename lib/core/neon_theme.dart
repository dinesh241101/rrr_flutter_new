import 'package:flutter/material.dart';

/// Semi-Neon theme with muted colors - Dark blue and black base
class NeonTheme {
  // Semi-Neon Primary Colors (muted and subtle)
  static const Color neonCyan = Color(0xFF0DB8D4); // Muted cyan
  static const Color neonMagenta = Color(0xFFB8008E); // Muted magenta
  static const Color neonPink = Color(0xFFD4476E); // Muted pink
  static const Color neonLime = Color(0xFF4CAF50); // Muted lime/green
  static const Color neonPurple = Color(0xFF7C3AED); // Muted purple
  static const Color neonOrange = Color(0xFFE67E22); // Muted orange
  static const Color neonYellow = Color(0xFFB8A600); // Muted yellow
  static const Color neonBlue = Color(0xFF1E88E5); // Muted blue

  // Muted Secondary Colors (darker variants)
  static const Color darkCyan = Color(0xFF0A7FA0);
  static const Color darkMagenta = Color(0xFF88006B);
  static const Color darkPink = Color(0xFFA0334A);
  static const Color darkPurple = Color(0xFF5B2FA0);

  // Dark Background Palette - Pure dark blue and black
  static const Color darkBg = Color(0xFF0D1117); // Almost black
  static const Color darkBg2 = Color(0xFF161B22); // Very dark blue
  static const Color darkBg3 = Color(0xFF21262D); // Dark blue
  static const Color darkCard = Color(0xFF0D1F2D); // Dark card background

  // Text Colors
  static const Color textLight = Color(0xFFC9D1D9);
  static const Color textPrimary = Color(0xFFF0F6FC);
  static const Color textMuted = Color(0xFF6E7681);

  // Subtle Gradients (less aggressive)
  static const LinearGradient neonCyanGradient = LinearGradient(
    colors: [neonCyan, darkCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient neonPinkGradient = LinearGradient(
    colors: [neonPink, darkPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient neonPurpleGradient = LinearGradient(
    colors: [neonPurple, darkPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient neonGreenGradient = LinearGradient(
    colors: [neonLime, Color(0xFF2E7D32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Multi-Color Subtle Gradient (muted for hero elements)
  static const LinearGradient rainbowNeonGradient = LinearGradient(
    colors: [neonCyan, neonPurple, neonPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Subtle Box Shadows (muted glow)
  static const List<BoxShadow> neonCyanShadow = [
    BoxShadow(
      color: neonCyan,
      blurRadius: 12,
      spreadRadius: 0,
      offset: Offset(0, 0),
    ),
  ];

  static const List<BoxShadow> neonPinkShadow = [
    BoxShadow(
      color: neonPink,
      blurRadius: 12,
      spreadRadius: 0,
      offset: Offset(0, 0),
    ),
  ];

  static const List<BoxShadow> neonPurpleShadow = [
    BoxShadow(
      color: neonPurple,
      blurRadius: 12,
      spreadRadius: 0,
      offset: Offset(0, 0),
    ),
  ];

  static List<BoxShadow> customNeonShadow(Color color) => [
    BoxShadow(
      color: color.withOpacity(0.3),
      blurRadius: 10,
      spreadRadius: 0,
      offset: const Offset(0, 0),
    ),
  ];

  // Subtle Borders
  static BorderSide neonCyanBorder([double width = 1.5]) =>
      BorderSide(color: neonCyan.withOpacity(0.6), width: width);

  static BorderSide neonPinkBorder([double width = 1.5]) =>
      BorderSide(color: neonPink.withOpacity(0.6), width: width);

  static BorderSide neonPurpleBorder([double width = 1.5]) =>
      BorderSide(color: neonPurple.withOpacity(0.6), width: width);

  static BorderSide neonLimeBorder([double width = 1.5]) =>
      BorderSide(color: neonLime.withOpacity(0.6), width: width);

  // Semi-Neon Theme Data
  static ThemeData getNeonThemeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      primaryColor: neonCyan,
      secondaryHeaderColor: neonPink,
      appBarTheme: AppBarTheme(
        backgroundColor: darkBg2,
        foregroundColor: neonCyan,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: neonCyan,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: neonCyan,
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        displayMedium: TextStyle(
          color: neonPink,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        headlineSmall: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: textLight, fontSize: 16),
        bodyMedium: TextStyle(color: textLight, fontSize: 14),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkBg2,
        selectedItemColor: neonCyan,
        unselectedItemColor: textMuted,
        elevation: 10,
      ),
      cardColor: darkCard,
      dialogBackgroundColor: darkBg2,
    );
  }

  /// Get contrasting colors for dynamic UI (muted palette)
  static List<Color> get neonColors => [
    neonCyan,
    neonPurple,
    neonPink,
    neonLime,
    neonBlue,
    neonOrange,
  ];
}
