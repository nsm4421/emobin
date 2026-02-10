import 'package:flutter/material.dart';

class AppFormSection extends StatelessWidget {
  const AppFormSection({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.spacing = 12,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final hasTitle = title != null && title!.trim().isNotEmpty;
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;
    final effectiveTitleStyle =
        titleStyle ?? Theme.of(context).textTheme.titleMedium;
    final effectiveSubtitleStyle =
        subtitleStyle ?? Theme.of(context).textTheme.bodySmall;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (hasTitle) Text(title!, style: effectiveTitleStyle),
        if (hasTitle && hasSubtitle) SizedBox(height: spacing / 2),
        if (hasSubtitle) Text(subtitle!, style: effectiveSubtitleStyle),
        if (hasTitle || hasSubtitle) SizedBox(height: spacing),
        child,
      ],
    );
  }
}
