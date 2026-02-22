part of 'pg_auth_entry.dart';

class _AuthEntryFeatures extends StatelessWidget {
  const _AuthEntryFeatures();

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppThemeModeCubit, bool>(
      (cubit) => cubit.state == ThemeMode.dark,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          _FeatureRow(
            icon: Icons.auto_awesome,
            text: context.l10n.authFeatureTrackMoments,
          ),
          const SizedBox(height: 12),
          _FeatureRow(
            icon: Icons.chat_bubble_outline,
            text: context.l10n.authFeatureReflectPrompts,
          ),
          const SizedBox(height: 12),
          _FeatureRow(
            icon: Icons.lock_outline,
            text: context.l10n.authFeaturePrivateSecure,
          ),
          const SizedBox(height: 16),
          Divider(color: context.colorScheme.outlineVariant),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.lightDarkMode,
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isDark
                          ? context.l10n.darkModeOnTapSwitch
                          : context.l10n.lightModeOnTapSwitch,
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Tooltip(
                message: isDark
                    ? context.l10n.switchToLightMode
                    : context.l10n.switchToDarkMode,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.colorScheme.outlineVariant,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      isDark ? Icons.dark_mode : Icons.light_mode,
                      color: context.colorScheme.primary,
                    ),
                    onPressed: () {
                      context.read<AppThemeModeCubit>().toggleBrightness();
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            color: context.colorScheme.primary.withAlpha(31),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: context.colorScheme.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: context.textTheme.bodyMedium)),
      ],
    );
  }
}
