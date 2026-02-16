part of 'auth_entry_screen.dart';

class _AuthEntryFeaturesSection extends StatelessWidget {
  const _AuthEntryFeaturesSection();

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
          const _FeatureRow(
            icon: Icons.auto_awesome,
            text: 'Track your moments in a simple way.',
          ),
          const SizedBox(height: 12),
          const _FeatureRow(
            icon: Icons.chat_bubble_outline,
            text: 'Reflect with prompts when you need them.',
          ),
          const SizedBox(height: 12),
          const _FeatureRow(
            icon: Icons.lock_outline,
            text: 'Your data stays private and secure.',
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
                      'Light / Dark mode',
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isDark
                          ? 'Dark mode is on. Tap to switch.'
                          : 'Light mode is on. Tap to switch.',
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Tooltip(
                message: isDark
                    ? 'Switch to light mode'
                    : 'Switch to dark mode',
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
