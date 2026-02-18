part of 'pg_edit_feed.dart';

class _EditFeedIntro extends StatelessWidget {
  const _EditFeedIntro();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text(
        'Edit your entry and save changes.',
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.onSurfaceVariant,
          height: 1.4,
        ),
      ),
    );
  }
}
