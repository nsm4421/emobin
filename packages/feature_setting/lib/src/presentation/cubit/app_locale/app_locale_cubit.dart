import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/keys.dart';

part 'app_locale_state.dart';

@lazySingleton
class AppLocaleCubit extends Cubit<AppLocaleState> {
  AppLocaleCubit(this._sharedPreferences) : super(_deviceLocale());

  final SharedPreferences _sharedPreferences;

  void initialize() {
    final languageCode = _sharedPreferences.getString(
      SettingPreferenceKeys.appLocale,
    );
    emit(_toSupportedLocale(languageCode ?? state.languageCode));
  }

  void setLocale(Locale locale) {
    final normalized = _toSupportedLocale(locale.languageCode);
    if (state == normalized) {
      return;
    }

    emit(normalized);
    _sharedPreferences.setString(
      SettingPreferenceKeys.appLocale,
      normalized.languageCode,
    );
  }

  Locale _toSupportedLocale(String? languageCode) {
    switch (languageCode) {
      case 'ko':
        return const Locale('ko');
      case 'ja':
        return const Locale('ja');
      default:
        return const Locale('en');
    }
  }

  static Locale _deviceLocale() {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    return switch (locale.languageCode) {
      'ko' => const Locale('ko'),
      'ja' => const Locale('ja'),
      _ => const Locale('en'),
    };
  }
}
