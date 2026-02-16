part of 'setting_entry_screen.dart';

class _SettingHeroSection extends StatelessWidget {
  const _SettingHeroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colorScheme.primary.withAlpha(22),
            context.colorScheme.tertiary.withAlpha(16),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(color: context.colorScheme.outlineVariant),
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: context.colorScheme.primary,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Guest User', style: context.textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  'Complete your profile to personalize Emobin.',
                  style: context.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          TextButton(onPressed: () {}, child: const Text('Edit')),
        ],
      ),
    );
  }
}
