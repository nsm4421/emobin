import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  EdgeInsets get viewPadding => mediaQuery.viewPadding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  EdgeInsets get safePadding => mediaQuery.padding;
  EdgeInsets get safeAreaPadding => mediaQuery.padding;
  double get textScaleFactor => MediaQuery.textScalerOf(this).scale(1.0);
  Brightness get platformBrightness => mediaQuery.platformBrightness;

  bool get isDarkMode => theme.brightness == Brightness.dark;
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;
  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;

  Color get primaryColor => colorScheme.primary;
  Color get onPrimaryColor => colorScheme.onPrimary;
  Color get secondaryColor => colorScheme.secondary;
  Color get onSecondaryColor => colorScheme.onSecondary;
  Color get tertiaryColor => colorScheme.tertiary;
  Color get onTertiaryColor => colorScheme.onTertiary;
  Color get surfaceColor => colorScheme.surface;
  Color get backgroundColor => colorScheme.surface;
}
