part of 'setting_entry_screen.dart';

class _SettingSectionCardWidget extends StatelessWidget {
  const _SettingSectionCardWidget({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Text(title, style: context.textTheme.titleSmall),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
}
