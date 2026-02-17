part of 'setting_entry_screen.dart';

class _SettingTileWidget extends StatelessWidget {
  const _SettingTileWidget({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.showBottomDivider = true,
    this.titleColor,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool showBottomDivider;
  final Color? titleColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: showBottomDivider
              ? Border(
                  bottom: BorderSide(color: context.colorScheme.outlineVariant),
                )
              : null,
        ),
        child: Row(
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withAlpha(24),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: context.colorScheme.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: titleColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: context.textTheme.bodySmall),
                  ],
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.colorScheme.onSurfaceVariant,
                ),
          ],
        ),
      ),
    );
  }
}
