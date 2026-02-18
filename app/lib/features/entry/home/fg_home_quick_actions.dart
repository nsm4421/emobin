part of 'pg_home_entry.dart';

class _HomeQuickActions extends StatelessWidget {
  const _HomeQuickActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: context.textTheme.titleSmall?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        _HomeQuickAction(
          icon: Icons.feed_rounded,
          title: 'Open Feed List',
          subtitle: 'Browse your recent journal entries.',
          onTap: () => context.tabsRouter.setActiveIndex(1),
        ),
        const SizedBox(height: 10),
        _HomeQuickAction(
          icon: Icons.insights_rounded,
          title: 'View Writing Insights',
          subtitle: 'Check weekly completion trend (mockup).',
          onTap: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Mockup action'))),
        ),
      ],
    );
  }
}
