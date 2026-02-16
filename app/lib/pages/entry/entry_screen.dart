import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:emobin/router/app_router.dart';
import 'package:flutter/material.dart';

part 'bottom_navigator_section.dart';

@RoutePage()
class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [HomeEntryRoute(), FeedEntryRoute(), SettingEntryRoute()],
      builder: (context, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: _BottomNavigatorSection(
            currentIndex: context.tabsRouter.activeIndex,
            onTap: context.tabsRouter.setActiveIndex,
          ),
        );
      },
    );
  }
}
