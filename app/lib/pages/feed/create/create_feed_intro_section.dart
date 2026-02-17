part of 'create_feed_page.dart';

class _CreateFeedIntroSection extends StatelessWidget {
  const _CreateFeedIntroSection();

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
