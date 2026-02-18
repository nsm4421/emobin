part of 'pg_edit_hashtag.dart';

class _HashtagIntro extends StatelessWidget {
  const _HashtagIntro();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 18,
          color: context.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Manage hashtag presets used while creating or editing feeds.',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
