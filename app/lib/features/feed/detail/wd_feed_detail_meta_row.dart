part of 'pg_feed_detail.dart';

class _FeedDetailMetaRow extends StatelessWidget {
  const _FeedDetailMetaRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: context.colorScheme.outlineVariant,
          ),
        if (showDivider) const SizedBox(height: 10),
      ],
    );
  }
}
