part of '../setting_entry_screen.dart';

class _SettingPreferencesSection extends StatelessWidget {
  const _SettingPreferencesSection();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select<AppThemeModeCubit, bool>(
      (cubit) => cubit.state == ThemeMode.dark,
    );

    return _SettingSectionCardWidget(
      title: 'Preferences',
      children: [
        _SettingTileWidget(
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
        _SettingTileWidget(
          icon: Icons.language_rounded,
          title: 'Language',
          subtitle: 'English',
          trailing: const _SettingValueLabelWidget('EN'),
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

class _SettingValueLabelWidget extends StatelessWidget {
  const _SettingValueLabelWidget(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(label, style: context.textTheme.labelSmall),
    );
  }
}
