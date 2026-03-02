part of 'pg_home_entry.dart';

class _HomeSyncMenu extends StatelessWidget {
  const _HomeSyncMenu();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.trashMenu,
          style: context.textTheme.titleSmall?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        _HomeQuickAction(
          icon: Icons.delete_outline_rounded,
          title: context.l10n.trashMenu,
          subtitle: context.l10n.trashMenuSubtitle,
          onTap: () => context.router.push(const FeedTrashRoute()),
        ),
      ],
    );
  }
}
