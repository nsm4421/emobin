part of 'toast_helper.dart';

enum _ToastType { success, error, warning }

class _ToastOverlay extends StatefulWidget {
  final String message;
  final VoidCallback onComplete;
  final _ToastType type;

  const _ToastOverlay({
    required this.message,
    required this.onComplete,
    required this.type,
  });

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _controller.forward();
    Future<void>.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;
      await _controller.reverse();
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (background, foreground, iconData, border) = _styleFor(
      context.colorScheme,
      widget.type,
    );

    return Positioned(
      left: 24,
      right: 24,
      bottom: 48,
      child: FadeTransition(
        opacity: _controller,
        child: Material(
          color: Colors.transparent,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(iconData, color: foreground, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: TextStyle(color: foreground),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

(Color, Color, IconData, Color) _styleFor(ColorScheme scheme, _ToastType type) {
  switch (type) {
    case _ToastType.success:
      return (
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
        Icons.check_circle,
        scheme.primary.withAlpha(120),
      );
    case _ToastType.warning:
      return (
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
        Icons.warning_amber_rounded,
        scheme.tertiary.withAlpha(120),
      );
    case _ToastType.error:
      return (
        scheme.errorContainer,
        scheme.onErrorContainer,
        Icons.error_outline,
        scheme.error.withAlpha(120),
      );
  }
}
