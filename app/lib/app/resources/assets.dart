import 'package:flutter/material.dart';

class AppAssets {
  static const String _svgBase = 'assets/svg';

  static String splash(Brightness brightness) {
    return brightness == Brightness.dark
        ? '$_svgBase/splash_dark.svg'
        : '$_svgBase/splash_light.svg';
  }
}
