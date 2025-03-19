import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryColor = Color(0xFF3674B5);  // Deep Blue
  static const Color secondaryColor = Color(0xFF578FCA); // Medium Blue
  static const Color accentColor = Color(0xFFA1E3F9);    // Light Blue
  static const Color tertiaryColor = Color(0xFFD1F8EF);  // Mint Green

  // Background Colors
  static const Color backgroundColor = Color(0xFFF8FAFB);
  static const Color cardColor = Colors.white;
  static const Color surfaceColor = Color(0xFFF5F5F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF718093);
  static const Color textLight = Color(0xFF95A5A6);

  // Status Colors
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF1C40F);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3674B5);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF3674B5),
    Color(0xFF578FCA),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFFA1E3F9),
    Color(0xFFD1F8EF),
  ];

  // Shadow
  static BoxShadow defaultShadow = BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );
} 