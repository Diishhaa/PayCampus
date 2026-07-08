import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF2563EB);      // Royal Blue
  static const Color secondary = Color(0xFF0F172A);    // Dark Navy
  static const Color accent = Color(0xFF22C55E);       // Success Green
  
  // Status Colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);      // Amber
  static const Color error = Color(0xFFEF4444);        // Red
  static const Color info = Color(0xFF3B82F6);         // Light Blue

  // Neutrals / Backgrounds
  static const Color background = Color(0xFFF8FAFC);   // Off-white Slate
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF111827);  // Dark Gray
  static const Color textSecondary = Color(0xFF6B7280);// Muted Slate
  static const Color textMuted = Color(0xFF9CA3AF);    // Light Slate
  static const Color border = Color(0xFFE2E8F0);       // Soft Gray Border
  
  // Custom Fintech Gradients
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient darkGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
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
      color: const Color(0xFF0F172A).withOpacity(0.04),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF0F172A).withOpacity(0.06),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];
}
