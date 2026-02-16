part of 'entry_screen.dart';

class _BottomNavigatorSection extends StatelessWidget {
  const _BottomNavigatorSection({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: context.colorScheme.primary,
      unselectedItemColor: context.colorScheme.onSurfaceVariant,
      backgroundColor: context.colorScheme.surface,
      showUnselectedLabels: false,
      onTap: (index) {
        if (index == currentIndex) return;
        onTap(index);
      },
      items: _HomeBottomNavigatorMenus.values
          .map(
            (menu) => BottomNavigationBarItem(
              icon: Icon(menu.iconData),
              activeIcon: Icon(menu.activeIconData),
              label: menu.label,
            ),
          )
          .toList(growable: false),
    );
  }
}

enum _HomeBottomNavigatorMenus {
  home(
    label: 'HOME',
    iconData: Icons.home_outlined,
    activeIconData: Icons.home,
  ),
  feed(
    label: 'FEED',
    iconData: Icons.feed_outlined,
    activeIconData: Icons.feed,
  ),
  settings(
    label: 'SETTING',
    iconData: Icons.settings_outlined,
    activeIconData: Icons.settings,
  );

  const _HomeBottomNavigatorMenus({
    required this.label,
    required this.iconData,
    this.activeIconData,
  });

  final String label;
  final IconData iconData;
  final IconData? activeIconData;
}
