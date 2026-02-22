part of '../pg_entry.dart';

extension HomeBottomNavigationMenuX on HomeBottomNavigationMenu {
  String label(BuildContext context) => switch (this) {
    HomeBottomNavigationMenu.home => context.l10n.homeTitle,
    HomeBottomNavigationMenu.feed => context.l10n.feedTitle,
    HomeBottomNavigationMenu.setting => context.l10n.settingTitle,
  };

  IconData get iconData => switch (this) {
    HomeBottomNavigationMenu.home => Icons.home_outlined,
    HomeBottomNavigationMenu.feed => Icons.feed_outlined,
    HomeBottomNavigationMenu.setting => Icons.settings_outlined,
  };

  IconData get activeIconData => switch (this) {
    HomeBottomNavigationMenu.home => Icons.home,
    HomeBottomNavigationMenu.feed => Icons.feed,
    HomeBottomNavigationMenu.setting => Icons.settings,
  };

  PageRouteInfo get route => switch (this) {
    HomeBottomNavigationMenu.home => HomeEntryRoute(),
    HomeBottomNavigationMenu.feed => FeedEntryRoute(),
    HomeBottomNavigationMenu.setting => SettingEntryRoute(),
  };
}
