import 'package:auto_route/auto_route.dart';
import 'package:emobin/app/resources/assets.dart';
import 'package:emobin/app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      context.router.replace(const EntryRoute());
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final assetPath = AppAssets.splash(brightness);

    final gradientColors = brightness == Brightness.dark
        ? const [Color(0xFF0B0D12), Color(0xFF151A23)]
        : const [Color(0xFFF7F9FE), Color(0xFFE9EEF8)];

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth * 0.75;
              final height = constraints.maxHeight * 0.45;
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      assetPath,
                      width: width,
                      height: height,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 32,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Emobin',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Move smart. Move light.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withAlpha(60),
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
