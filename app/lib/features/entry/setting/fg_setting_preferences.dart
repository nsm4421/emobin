part of 'pg_setting_entry.dart';

class _SettingPreferences extends StatelessWidget {
  const _SettingPreferences();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select<AppThemeModeCubit, bool>(
      (cubit) => cubit.state == ThemeMode.dark,
    );
    final locale = context.select<AppLocaleCubit, Locale>(
      (cubit) => cubit.state,
    );

    return _SettingSectionCard(
      title: context.l10n.preferencesTitle,
      children: [
        _SettingTile(
          icon: Icons.dark_mode_rounded,
          title: context.l10n.darkMode,
          subtitle: isDarkMode ? context.l10n.onLabel : context.l10n.offLabel,
          onTap: () => context.read<AppThemeModeCubit>().toggleBrightness(),
          trailing: Switch.adaptive(
            value: isDarkMode,
            onChanged: (_) =>
                context.read<AppThemeModeCubit>().toggleBrightness(),
          ),
        ),
        _SettingTile(
          icon: Icons.language_rounded,
          title: context.l10n.language,
          subtitle: _languageLabel(context, locale),
          trailing: _SettingValueLabel(_languageCodeLabel(locale)),
          onTap: () => _showLanguagePicker(context),
          showBottomDivider: false,
        ),
      ],
    );
  }

  Future<void> _showLanguagePicker(BuildContext context) async {
    final localeCubit = context.read<AppLocaleCubit>();
    final selectedLanguageCode = localeCubit.state.languageCode;

    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text('🇺🇸', style: TextStyle(fontSize: 22)),
                title: const Text('English'),
                trailing: selectedLanguageCode == 'en'
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () {
                  localeCubit.setLocale(const Locale('en'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Text('🇰🇷', style: TextStyle(fontSize: 22)),
                title: const Text('한국어'),
                trailing: selectedLanguageCode == 'ko'
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () {
                  localeCubit.setLocale(const Locale('ko'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Text('🇯🇵', style: TextStyle(fontSize: 22)),
                title: const Text('日本語'),
                trailing: selectedLanguageCode == 'ja'
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () {
                  localeCubit.setLocale(const Locale('ja'));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _languageLabel(BuildContext context, Locale locale) {
    return switch (locale.languageCode) {
      'ko' => context.l10n.korean,
      'ja' => context.l10n.japanese,
      _ => context.l10n.english,
    };
  }

  String _languageCodeLabel(Locale locale) {
    return switch (locale.languageCode) {
      'ko' => 'KO',
      'ja' => 'JA',
      _ => 'EN',
    };
  }
}
