part of 'home_screen.dart';

class _HomeFeedStatusSection extends StatelessWidget {
  const _HomeFeedStatusSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Journal Status',
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'No entry yet. Capture today before it slips away.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: _HomeStatusMetricWidget(
                  icon: Icons.local_fire_department_rounded,
                  label: 'Streak',
                  value: '4 days',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _HomeStatusMetricWidget(
                  icon: Icons.today_rounded,
                  label: 'Today',
                  value: 'Pending',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _HomeStatusMetricWidget(
                  icon: Icons.edit_calendar_rounded,
                  label: 'This Week',
                  value: '3 / 7',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
