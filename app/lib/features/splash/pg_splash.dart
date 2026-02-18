import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:emobin/core/constants/assets.dart';
import 'package:emobin/router/app_router.dart';
import 'package:feature_security/feature_security.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

part 'sc_splash.dart';

@RoutePage(name: 'SplashRoute')
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  static const _minimumVisibleDuration = Duration(seconds: 2);
  bool _isDelayCompleted = false;
  bool _didNavigate = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(_minimumVisibleDuration, _onDelayCompleted);
  }

  void _onDelayCompleted() {
    if (!mounted) return;
    _isDelayCompleted = true;
    _tryNavigate(context.read<SecurityBloc>().state);
  }

  void _tryNavigate(SecurityState state) {
    if (!_isDelayCompleted || _didNavigate) return;

    state.whenOrNull(
      locked: (_) {
        _didNavigate = true;
        context.router.replaceAll([const ValidatePasswordRoute()]);
      },
      unlocked: (_, __) {
        _didNavigate = true;
        context.router.replaceAll([const EntryRoute()]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SecurityBloc, SecurityState>(
      listener: (context, state) {
        _tryNavigate(state);
      },
      child: const _Splash(),
    );
  }
}
