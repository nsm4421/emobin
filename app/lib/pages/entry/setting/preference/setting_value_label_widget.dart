part of '../setting_entry_screen.dart';

class _SettingValueLabelWidget extends StatelessWidget {
  const _SettingValueLabelWidget(this.label);

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
