import 'package:feature_auth/feature_auth.dart';
import 'package:flutter/material.dart';
import 'package:emobin/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ui_theme/ui_theme.dart';

import 'core/di/di.dart';
import 'core/toast/toast_helper.dart';

void main() {
  configureDependencies();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<AuthBloc>()..add(AuthEvent.started()),
      child: MaterialApp.router(
        title: 'EmoBin',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter(navigatorKey: toastNavigatorKey).config(),
      ),
    );
  }
}
