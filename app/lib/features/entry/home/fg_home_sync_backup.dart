part of 'pg_home_entry.dart';

class _HomeSyncBackup extends StatelessWidget {
  const _HomeSyncBackup();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.syncAndBackup,
          style: context.textTheme.titleSmall?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        _HomeQuickAction(
          icon: Icons.sync_rounded,
          title: context.l10n.syncMenu,
          subtitle: context.l10n.syncMenuSubtitle,
          onTap: () => context.router.push(const FeedSyncRoute()),
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
