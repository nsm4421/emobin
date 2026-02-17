part of 'home_bottom_navigation_cubit.dart';

enum HomeBottomNavigationMenu { home, feed, setting }

class HomeBottomNavigationState {
  final HomeBottomNavigationMenu menu;
  final bool visible;

  HomeBottomNavigationState({
    this.menu = HomeBottomNavigationMenu.home,
    this.visible = true,
  });

  HomeBottomNavigationState copyWith({
    HomeBottomNavigationMenu? menu,
    bool? visible,
  }) => HomeBottomNavigationState(
    menu: menu ?? this.menu,
    visible: visible ?? this.visible,
  );
}
