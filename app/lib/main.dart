import 'package:emobin/providers/cubit/app_theme/app_theme_cubit.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:flutter/material.dart';
import 'package:emobin/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

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
    final router = AppRouter(navigatorKey: toastNavigatorKey);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetIt.instance<AuthBloc>()..add(AuthEvent.started()),
        ),
        BlocProvider(
          create: (_) => GetIt.instance<AppThemeModeCubit>()..initialize(),
        ),
      ],
      child: BlocBuilder<AppThemeModeCubit, ThemeMode>(
        builder: (context, state) {
          final cubit = context.read<AppThemeModeCubit>();
          return MaterialApp.router(
            title: 'EmoBin',
            theme: cubit.lightThemeData,
            darkTheme: cubit.darkThemeData,
            themeMode: state,
            routerConfig: router.config(),
          );
        },
      ),
    );
  }
}
