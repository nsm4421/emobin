import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_theme/ui_theme.dart';

import '../../../core/constants/keys.dart';

part 'app_theme_mode_state.dart';

@lazySingleton
class AppThemeModeCubit extends Cubit<AppThemeModeState> {
  AppThemeModeCubit(this._sharedPreferences) : super(ThemeMode.system);

  final SharedPreferences _sharedPreferences;

  ThemeData get lightThemeData => AppTheme.light;

  ThemeData get darkThemeData => AppTheme.dark;

  void initialize() {
    final value = _sharedPreferences.getString(
      SettingPreferenceKeys.appThemeMode,
    );
    final isDark = value == ThemeMode.dark.name;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleBrightness() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(next);
    _sharedPreferences.setString(SettingPreferenceKeys.appThemeMode, next.name);
  }
}
