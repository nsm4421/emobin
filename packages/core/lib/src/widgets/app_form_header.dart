import 'package:flutter/material.dart';

class AppFormHeader extends StatelessWidget {
  const AppFormHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.spacing = 8,
  });

  final String title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final effectiveTitleStyle =
        titleStyle ?? Theme.of(context).textTheme.headlineMedium;
    final effectiveSubtitleStyle =
        subtitleStyle ?? Theme.of(context).textTheme.bodyMedium;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(title, style: effectiveTitleStyle),
        if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
          SizedBox(height: spacing),
          Text(subtitle!, style: effectiveSubtitleStyle),
        ],
      ],
    );
  }
}
