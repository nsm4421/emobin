import 'package:flutter/material.dart';

/// 텍스트 링크 스타일을 통일하기 위한 공용 위젯.
class AppTextLink extends StatelessWidget {
  const AppTextLink({
    super.key,
    required this.label,
    this.onPressed,
    this.style,
    this.alignment = Alignment.centerLeft,
  });

  /// 표시할 라벨 텍스트.
  final String label;

  /// 클릭 시 호출.
  final VoidCallback? onPressed;

  /// 링크 텍스트 스타일.
  final TextStyle? style;

  /// 버튼 정렬.
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ??
        Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            );

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: alignment,
      ),
      child: Text(label, style: effectiveStyle),
    );
  }
}
