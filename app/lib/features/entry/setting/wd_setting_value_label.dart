part of 'pg_setting_entry.dart';

class _SettingValueLabel extends StatelessWidget {
  const _SettingValueLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(label, style: context.textTheme.labelSmall),
    );
  }
}
