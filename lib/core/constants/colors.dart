import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF2E41B6);      // Deep Indigo
  static const Color secondary = Color(0xFF0B1C30);    // Dark Navy / Slate
  static const Color accent = Color(0xFF3EB489);       // Mint Teal
  
  // Status Colors
  static const Color success = Color(0xFF3EB489);      // Mint Teal
  static const Color warning = Color(0xFFF59E0B);      // Amber
  static const Color error = Color(0xFFBA1A1A);        // Fintech Red
  static const Color info = Color(0xFF7C3AED);         // Subtle Violet

  // Neutrals / Backgrounds
  static const Color background = Color(0xFFF8F9FF);   // Soft Off-white Indigo
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0B1C30);  // Dark Navy Text
  static const Color textSecondary = Color(0xFF64748B);// Muted Slate Text
  static const Color textMuted = Color(0xFF757685);    // Light Slate Text
  static const Color border = Color(0xFFE2E8F0);       // Soft Gray Border
  
  // Custom Fintech Gradients
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2E41B6), Color(0xFF1D2E9C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient darkGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0B0E14)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient successGradient = LinearGradient(
    colors: [Color(0xFF3EB489), Color(0xFF2E9E75)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient glassGradient = LinearGradient(
    colors: [
      Color(0x33FFFFFF),
      Color(0x11FFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Soft shadows
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFF0B1C30).withOpacity(0.04),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF0B1C30).withOpacity(0.06),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];
}
