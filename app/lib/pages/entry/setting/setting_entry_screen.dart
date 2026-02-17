import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:emobin/core/toast/toast_helper.dart';
import 'package:emobin/router/app_router.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_setting/feature_setting.dart';
import 'package:feature_security/feature_security.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting_hero_section.dart';
part 'preference/setting_preferences_section.dart';
part 'preference/setting_value_label_widget.dart';
part 'setting_section_card_widget.dart';
part 'setting_tile_widget.dart';
part 'security/has_password_widget.dart';
part 'security/has_not_password_widget.dart';
part 'security/edit_password_modal_widget.dart';
part 'security/edit_password_modal_state_widget.dart';
part 'security/setting_security_section.dart';

@RoutePage()
class SettingEntryScreen extends StatelessWidget {
  const SettingEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SETTING')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: const [
            _SettingHeroSection(),
            SizedBox(height: 16),
            _SettingPreferencesSection(),
            SizedBox(height: 16),
            _SettingSecuritySection(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
