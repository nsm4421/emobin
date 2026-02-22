part of 'pg_entry.dart';

class _BottomNavigator extends StatelessWidget {
  const _BottomNavigator();

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
                        label: menu.label(context),
                      ),
                    )
                    .toList(growable: false),
              )
            : SizedBox.shrink();
      },
    );
  }
}
