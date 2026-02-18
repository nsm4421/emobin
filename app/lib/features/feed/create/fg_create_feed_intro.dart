part of 'pg_create_feed.dart';

class _CreateFeedIntro extends StatelessWidget {
  const _CreateFeedIntro();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text(
        'Capture how you feel today.\nThere is no right answer, just be honest.',
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.onSurfaceVariant,
          height: 1.4,
        ),
      ),
    );
  }
}
