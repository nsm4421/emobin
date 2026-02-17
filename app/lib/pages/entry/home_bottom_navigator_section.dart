part of 'entry_screen.dart';

class _BottomNavigatorSection extends StatelessWidget {
  const _BottomNavigatorSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBottomNavigationCubit, HomeBottomNavigationState>(
      builder: (context, state) {
        return state.visible
            ? BottomNavigationBar(
                currentIndex: context.tabsRouter.activeIndex,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: context.colorScheme.primary,
                unselectedItemColor: context.colorScheme.onSurfaceVariant,
                backgroundColor: context.colorScheme.surface,
                showUnselectedLabels: false,
                onTap: (index) {
                  context
                    ..tabsRouter.setActiveIndex(index)
                    ..read<HomeBottomNavigationCubit>().handleIndex(index);
                },
                items: HomeBottomNavigationMenu.values
                    .map(
                      (menu) => BottomNavigationBarItem(
                        icon: Icon(menu.iconData),
                        activeIcon: Icon(menu.activeIconData),
                        label: menu.label,
                      ),
                    )
                    .toList(growable: false),
              )
            : SizedBox.shrink();
      },
    );
  }
}
