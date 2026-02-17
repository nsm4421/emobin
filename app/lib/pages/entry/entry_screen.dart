import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:emobin/providers/cubit/home_bottom_navigation/home_bottom_navigation_cubit.dart';
import 'package:emobin/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'home_bottom_navigator_section.dart';

part 'home_bottom_navigation_x.dart';

@RoutePage()
class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<HomeBottomNavigationCubit>(),
      child: AutoTabsRouter(
        routes: HomeBottomNavigationMenu.values
            .map((e) => e.route)
            .toList(growable: false),
        builder: (context, child) {
          return Scaffold(
            body: child,
            bottomNavigationBar: _BottomNavigatorSection(),
          );
        },
      ),
    );
  }
}
