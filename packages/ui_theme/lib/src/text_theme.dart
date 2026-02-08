import 'package:flutter/material.dart';

import 'palette.dart';

@immutable
class AppTextThemes {
  const AppTextThemes._();

  static const String fontFamily = 'Noto Sans KR';
  static const List<String> fontFallback = [
    'Apple SD Gothic Neo',
    'Noto Sans CJK KR',
    'Malgun Gothic',
  ];

  static final TextTheme light = _base(
    primary: AppPalette.textPrimary,
    secondary: AppPalette.textSecondary,
    tertiary: AppPalette.textTertiary,
  );

  static final TextTheme dark = _base(
    primary: AppPalette.gray50,
    secondary: AppPalette.gray200,
    tertiary: AppPalette.gray300,
  );

  static TextTheme _base({
    required Color primary,
    required Color secondary,
    required Color tertiary,
  }) {
    return TextTheme(
      displayLarge: _style(57, 64, FontWeight.w700, primary),
      displayMedium: _style(45, 52, FontWeight.w700, primary),
      displaySmall: _style(36, 44, FontWeight.w700, primary),
      headlineLarge: _style(32, 40, FontWeight.w600, primary),
      headlineMedium: _style(28, 36, FontWeight.w600, primary),
      headlineSmall: _style(24, 32, FontWeight.w600, primary),
      titleLarge: _style(22, 28, FontWeight.w600, primary),
      titleMedium: _style(16, 24, FontWeight.w600, primary),
      titleSmall: _style(14, 20, FontWeight.w600, primary),
      bodyLarge: _style(16, 24, FontWeight.w400, primary),
      bodyMedium: _style(14, 20, FontWeight.w400, primary),
      bodySmall: _style(12, 16, FontWeight.w400, secondary),
      labelLarge: _style(14, 20, FontWeight.w600, primary),
      labelMedium: _style(12, 16, FontWeight.w600, secondary),
      labelSmall: _style(11, 16, FontWeight.w600, tertiary),
    );
  }

  static TextStyle _style(
    double size,
    double lineHeight,
    FontWeight weight,
    Color color,
  ) {
    return TextStyle(
      fontSize: size,
      height: lineHeight / size,
      fontWeight: weight,
      color: color,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      letterSpacing: 0,
    );
  }
}
