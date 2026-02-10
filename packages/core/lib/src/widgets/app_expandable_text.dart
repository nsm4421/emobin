import 'package:flutter/material.dart';

import 'app_text_link.dart';

/// 긴 텍스트를 지정한 줄 수로 접었다/펼치는 위젯.
class AppExpandableText extends StatefulWidget {
  const AppExpandableText({
    super.key,
    required this.text,
    this.maxLines = 3,
    this.style,
    this.linkStyle,
    this.moreLabel = 'Show more',
    this.lessLabel = 'Show less',
    this.textAlign,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.initiallyExpanded = false,
    this.alwaysShowToggle = false,
  });

  /// 표시할 텍스트.
  final String text;

  /// 접혔을 때 보이는 최대 줄 수.
  final int maxLines;

  /// 본문 텍스트 스타일.
  final TextStyle? style;

  /// 토글 링크 텍스트 스타일.
  final TextStyle? linkStyle;

  /// 펼치기 버튼 라벨.
  final String moreLabel;

  /// 접기 버튼 라벨.
  final String lessLabel;

  /// 텍스트 정렬.
  final TextAlign? textAlign;

  /// 컬럼 정렬.
  final CrossAxisAlignment crossAxisAlignment;

  /// 초기 확장 여부.
  final bool initiallyExpanded;

  /// 텍스트가 짧아도 토글을 항상 보여줄지 여부.
  final bool alwaysShowToggle;

  @override
  State<AppExpandableText> createState() => _AppExpandableTextState();
}

class _AppExpandableTextState extends State<AppExpandableText> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  void didUpdateWidget(covariant AppExpandableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initiallyExpanded != widget.initiallyExpanded) {
      _expanded = widget.initiallyExpanded;
    }
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStyle =
        DefaultTextStyle.of(context).style.merge(widget.style);

    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: effectiveStyle),
          textDirection: Directionality.of(context),
          textAlign: widget.textAlign ?? TextAlign.start,
          maxLines: widget.maxLines,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflowing = painter.didExceedMaxLines;
        final showToggle = widget.alwaysShowToggle || isOverflowing;

        return Column(
          crossAxisAlignment: widget.crossAxisAlignment,
          children: [
            Text(
              widget.text,
              style: widget.style,
              textAlign: widget.textAlign,
              maxLines: _expanded ? null : widget.maxLines,
              overflow:
                  _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (showToggle)
              Align(
                alignment: _alignmentFor(widget.crossAxisAlignment),
                child: AppTextLink(
                  label: _expanded ? widget.lessLabel : widget.moreLabel,
                  onPressed: _toggle,
                  style: widget.linkStyle,
                ),
              ),
          ],
        );
      },
    );
  }

  Alignment _alignmentFor(CrossAxisAlignment alignment) {
    switch (alignment) {
      case CrossAxisAlignment.center:
        return Alignment.center;
      case CrossAxisAlignment.end:
        return Alignment.centerRight;
      case CrossAxisAlignment.start:
      case CrossAxisAlignment.stretch:
      case CrossAxisAlignment.baseline:
        return Alignment.centerLeft;
    }
  }
}
