import 'package:flutter/material.dart';

import 'palette.dart';

@immutable
class AppColorSchemes {
  const AppColorSchemes._();

  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: AppPalette.primary,
    onPrimary: AppPalette.onPrimary,
    primaryContainer: AppPalette.primaryContainer,
    onPrimaryContainer: AppPalette.onPrimaryContainer,
    secondary: AppPalette.secondary,
    onSecondary: AppPalette.onSecondary,
    secondaryContainer: AppPalette.secondaryContainer,
    onSecondaryContainer: AppPalette.onSecondaryContainer,
    tertiary: AppPalette.tertiary,
    onTertiary: AppPalette.onTertiary,
    tertiaryContainer: AppPalette.tertiaryContainer,
    onTertiaryContainer: AppPalette.onTertiaryContainer,
    error: AppPalette.error,
    onError: AppPalette.onError,
    errorContainer: AppPalette.errorContainer,
    onErrorContainer: AppPalette.onErrorContainer,
    background: AppPalette.background,
    onBackground: AppPalette.onBackground,
    surface: AppPalette.surface,
    onSurface: AppPalette.onSurface,
    surfaceVariant: AppPalette.surfaceVariant,
    onSurfaceVariant: AppPalette.onSurfaceVariant,
    outline: AppPalette.outline,
    outlineVariant: AppPalette.outlineVariant,
    shadow: AppPalette.black,
    scrim: AppPalette.black,
    inverseSurface: AppPalette.inverseSurface,
    onInverseSurface: AppPalette.onInverseSurface,
    inversePrimary: AppPalette.inversePrimary,
  );

  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: AppPalette.primaryLight,
    onPrimary: AppPalette.black,
    primaryContainer: AppPalette.primaryDark,
    onPrimaryContainer: AppPalette.onPrimaryContainer,
    secondary: AppPalette.secondaryLight,
    onSecondary: AppPalette.black,
    secondaryContainer: AppPalette.secondaryDark,
    onSecondaryContainer: AppPalette.onSecondaryContainer,
    tertiary: AppPalette.tertiaryLight,
    onTertiary: AppPalette.black,
    tertiaryContainer: AppPalette.tertiaryDark,
    onTertiaryContainer: AppPalette.onTertiaryContainer,
    error: AppPalette.error,
    onError: AppPalette.onError,
    errorContainer: AppPalette.errorContainer,
    onErrorContainer: AppPalette.onErrorContainer,
    background: AppPalette.gray900,
    onBackground: AppPalette.gray50,
    surface: AppPalette.gray800,
    onSurface: AppPalette.gray50,
    surfaceVariant: AppPalette.gray700,
    onSurfaceVariant: AppPalette.gray200,
    outline: AppPalette.gray600,
    outlineVariant: AppPalette.gray700,
    shadow: AppPalette.black,
    scrim: AppPalette.black,
    inverseSurface: AppPalette.gray50,
    onInverseSurface: AppPalette.gray900,
    inversePrimary: AppPalette.primary,
  );
}
