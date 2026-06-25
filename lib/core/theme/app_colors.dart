import 'package:flutter/material.dart';

// >>> AppColors =======================
// All color tokens for the YTDown design system
abstract class AppColors {
  // Primary
  static const Color primary = Color(0xFFFF0000);
  static const Color primaryVariant = Color(0xFFCC0000);
  static const Color onPrimary = Colors.white;

  // Surface - Dark
  static const Color surfaceDark = Color(0xFF0F0F0F);
  static const Color surfaceCardDark = Color(0xFF1A1A1A);
  static const Color surfaceElevatedDark = Color(0xFF242424);

  // Surface - Light
  static const Color surfaceLight = Color(0xFFF5F5F5);
  static const Color surfaceCardLight = Color(0xFFFFFFFF);

  // Surface - AMOLED
  static const Color surfaceAmoled = Color(0xFF000000);
  static const Color surfaceCardAmoled = Color(0xFF0D0D0D);

  // Text - Dark
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFAAAAAA);

  // Text - Light
  static const Color textPrimaryLight = Color(0xFF0F0F0F);
  static const Color textSecondaryLight = Color(0xFF606060);

  // Status
  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFFAB00);
  static const Color error = Color(0xFFFF5252);
  static const Color info = Color(0xFF448AFF);

  // Download status
  static const Color downloading = Color(0xFF448AFF);
  static const Color paused = Color(0xFFFFAB00);
  static const Color completed = Color(0xFF00C853);
  static const Color failed = Color(0xFFFF5252);
}
// <<< AppColors =======================
