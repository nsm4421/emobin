part of 'pg_setting_entry.dart';

class _SettingPreferences extends StatelessWidget {
  const _SettingPreferences();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select<AppThemeModeCubit, bool>(
      (cubit) => cubit.state == ThemeMode.dark,
    );

    return _SettingSectionCard(
      title: 'Preferences',
      children: [
        _SettingTile(
          icon: Icons.dark_mode_rounded,
          title: 'Dark Mode',
          subtitle: isDarkMode ? 'ON' : 'OFF',
          onTap: () => context.read<AppThemeModeCubit>().toggleBrightness(),
          trailing: Switch.adaptive(
            value: isDarkMode,
            onChanged: (_) =>
                context.read<AppThemeModeCubit>().toggleBrightness(),
          ),
        ),
        _SettingTile(
          icon: Icons.language_rounded,
          title: 'Language',
          subtitle: 'English',
          trailing: const _SettingValueLabel('EN'),
          onTap: () => _showLanguagePicker(context),
          showBottomDivider: false,
        ),
      ],
    );
  }

  Future<void> _showLanguagePicker(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language_rounded),
                title: const Text('English'),
                subtitle: const Text('Mockup only'),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: const Icon(Icons.translate_rounded),
                title: const Text('Korean'),
                subtitle: const Text('Mockup only'),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }
}
