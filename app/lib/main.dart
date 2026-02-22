import 'package:feature_auth/feature_auth.dart';
import 'package:feature_security/feature_security.dart';
import 'package:emobin/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:emobin/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:feature_setting/feature_setting.dart';

import 'core/di/di.dart';
import 'core/toast/toast_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouterConfig = AppRouter(navigatorKey: toastNavigatorKey).config();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetIt.instance<AuthBloc>()..add(AuthEvent.started()),
        ),
        BlocProvider(
          create: (_) =>
              GetIt.instance<SecurityBloc>()..add(SecurityEvent.started()),
        ),
        BlocProvider(
          create: (_) => GetIt.instance<AppThemeModeCubit>()..initialize(),
        ),
        BlocProvider(
          create: (_) => GetIt.instance<AppLocaleCubit>()..initialize(),
        ),
      ],
      child: BlocBuilder<AppLocaleCubit, Locale>(
        builder: (context, locale) {
          return BlocBuilder<AppThemeModeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final themeCubit = context.read<AppThemeModeCubit>();
              return MaterialApp.router(
                title: 'EmoBin',
                theme: themeCubit.lightThemeData,
                darkTheme: themeCubit.darkThemeData,
                themeMode: themeMode,
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                routerConfig: appRouterConfig,
              );
            },
          );
        },
      ),
    );
  }
}
