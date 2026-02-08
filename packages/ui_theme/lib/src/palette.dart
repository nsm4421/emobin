import 'package:flutter/material.dart';

@immutable
class AppPalette {
  const AppPalette._();

  // Core
  static const Color white = Color(0xFFF6F8FB);
  static const Color black = Color(0xFF0B0E12);

  // Neutrals
  static const Color gray50 = Color(0xFFF4F7FB);
  static const Color gray100 = Color(0xFFE9EFF6);
  static const Color gray200 = Color(0xFFD7E0EA);
  static const Color gray300 = Color(0xFFC1CCD8);
  static const Color gray400 = Color(0xFFA7B4C2);
  static const Color gray500 = Color(0xFF8A97A6);
  static const Color gray600 = Color(0xFF6F7B88);
  static const Color gray700 = Color(0xFF56606B);
  static const Color gray800 = Color(0xFF3E4650);
  static const Color gray900 = Color(0xFF2A3038);

  // Brand (muted, dusty, melancholic)
  static const Color primary = Color(0xFF5E6B8A);
  static const Color onPrimary = white;
  static const Color primaryContainer = Color(0xFF2F3A4E);
  static const Color onPrimaryContainer = Color(0xFFE8EDF4);
  static const Color primaryLight = Color(0xFFA9B7CC);
  static const Color primaryDark = Color(0xFF3F4C66);

  static const Color secondary = Color(0xFF4F7A88);
  static const Color onSecondary = white;
  static const Color secondaryContainer = Color(0xFF2D4650);
  static const Color onSecondaryContainer = Color(0xFFE6F0F3);
  static const Color secondaryLight = Color(0xFF8FB6C2);
  static const Color secondaryDark = Color(0xFF355965);

  static const Color tertiary = Color(0xFF6B5E8E);
  static const Color onTertiary = white;
  static const Color tertiaryContainer = Color(0xFF3E3552);
  static const Color onTertiaryContainer = Color(0xFFECE8F5);
  static const Color tertiaryLight = Color(0xFFB0A1CC);
  static const Color tertiaryDark = Color(0xFF4C3F66);

  // Semantic (muted tones)
  static const Color success = Color(0xFF4C7A6E);
  static const Color warning = Color(0xFF8A7B55);
  static const Color error = Color(0xFF9A4F5A);
  static const Color info = Color(0xFF4B6C8A);
  static const Color onError = white;
  static const Color errorContainer = Color(0xFF4A2A31);
  static const Color onErrorContainer = Color(0xFFF2E8EC);

  // Surfaces
  static const Color background = gray50;
  static const Color onBackground = gray900;
  static const Color surface = Color(0xFFF0F4F9);
  static const Color onSurface = gray900;
  static const Color surfaceAlt = gray100;
  static const Color surfaceVariant = gray200;
  static const Color onSurfaceVariant = gray700;
  static const Color border = gray200;
  static const Color outline = gray300;
  static const Color outlineVariant = gray200;
  static const Color inverseSurface = gray900;
  static const Color onInverseSurface = gray50;
  static const Color inversePrimary = primaryLight;

  // Text
  static const Color textPrimary = gray900;
  static const Color textSecondary = gray600;
  static const Color textTertiary = gray500;
}
