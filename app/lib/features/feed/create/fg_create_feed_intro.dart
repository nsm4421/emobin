part of 'pg_create_feed.dart';

class _CreateFeedIntro extends StatelessWidget {
  const _CreateFeedIntro();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text(
        'Capture today with up to 3 hashtags.\nKeep it simple and meaningful.',
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.onSurfaceVariant,
          height: 1.4,
        ),
      ),
    );
  }
}
