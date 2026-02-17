import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class SettingModule {
  @preResolve
  Future<SharedPreferences> get sp => SharedPreferences.getInstance();
}
