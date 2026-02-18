part of 'pg_auth_entry.dart';

class _AuthEntryBackground extends StatelessWidget {
  const _AuthEntryBackground({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  context.colorScheme.primary.withAlpha(20),
                  context.colorScheme.surface,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -80,
          right: -40,
          child: _DecorCircle(
            size: 220,
            color: context.colorScheme.primary.withAlpha(31),
          ),
        ),
        Positioned(
          bottom: -60,
          left: -30,
          child: _DecorCircle(
            size: 180,
            color: context.colorScheme.tertiary.withAlpha(31),
          ),
        ),
        child,
      ],
    );
  }
}

class _DecorCircle extends StatelessWidget {
  const _DecorCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
