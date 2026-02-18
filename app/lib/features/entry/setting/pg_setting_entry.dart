import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:emobin/core/toast/toast_helper.dart';
import 'package:emobin/router/app_router.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_setting/feature_setting.dart';
import 'package:feature_security/feature_security.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'fg_setting_hero.dart';
part 'fg_setting_preferences.dart';
part 'wd_setting_value_label.dart';
part 'wd_setting_section_card.dart';
part 'wd_setting_tile.dart';
part 'wd_has_password.dart';
part 'wd_has_not_password.dart';
part 'wd_edit_password_modal.dart';
part 'wd_edit_password_modal_state.dart';
part 'fg_setting_security.dart';

@RoutePage(name: 'SettingEntryRoute')
class SettingEntry extends StatelessWidget {
  const SettingEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SETTING')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: const [
            _SettingHero(),
            SizedBox(height: 16),
            _SettingPreferences(),
            SizedBox(height: 16),
            _SettingSecurity(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
