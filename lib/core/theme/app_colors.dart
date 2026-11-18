import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color electricIndigo = Color(0xFF6C63FF);
  static const Color cyanGlow = Color(0xFF00D9FF);
  static const Color amberWarning = Color(0xFFFFB347);
  
  // Neutral / Background Palette
  static const Color deepSpace = Color(0xFF0D0D1A);
  static const Color darkCard = Color(0xFF1A1A2E);
  static const Color surfaceOverlay = Color(0xFF252545);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0C3);
  static const Color textMuted = Color(0xFF6E6E82);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [electricIndigo, Color(0xFF8B84FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0x1AFFFFFF),
      Color(0x05FFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
