import 'package:flutter/material.dart';
import 'package:emobin/app/router/app_router.dart';
import 'package:ui_theme/ui_theme.dart';

import 'di/di.dart';

void main() {
  configureDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EmoBin',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter().config(),
    );
  }
}
