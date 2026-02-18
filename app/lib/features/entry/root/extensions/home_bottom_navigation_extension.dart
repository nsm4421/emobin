part of '../pg_entry.dart';

extension HomeBottomNavigationMenuX on HomeBottomNavigationMenu {
  String get label => switch (this) {
    HomeBottomNavigationMenu.home => 'HOME',
    HomeBottomNavigationMenu.feed => 'FEED',
    HomeBottomNavigationMenu.setting => 'SETTING',
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
