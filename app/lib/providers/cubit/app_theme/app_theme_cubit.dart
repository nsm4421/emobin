import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_theme/ui_theme.dart';

@lazySingleton
class AppThemeModeCubit extends Cubit<ThemeMode> {
  final SharedPreferences _sharedPreferences;
  static const String _kAppThemeModeKey = 'APP_THEME_MODE';

  AppThemeModeCubit(this._sharedPreferences) : super(ThemeMode.system);

  @lazySingleton
  ThemeData get lightThemeData => AppTheme.light;

  @lazySingleton
  ThemeData get darkThemeData => AppTheme.dark;

  void initialize() {
    try {
      final value = _sharedPreferences.getString(_kAppThemeModeKey);
      final isDark = value == ThemeMode.dark.name;
      final next = isDark ? ThemeMode.dark : ThemeMode.light;
      emit(next);
    } catch (error, stackTrace) {
      AppLogger.log(
        'Failed to initialize theme mode.',
        level: LogLevel.error,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void toggleBrightness() {
    try {
      final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      emit(next);
      _sharedPreferences.setString(_kAppThemeModeKey, state.name);
    } catch (error, stackTrace) {
      AppLogger.log(
        'Failed to toggle theme mode.',
        level: LogLevel.error,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
