import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'home_bottom_navigation_state.dart';

@injectable
class HomeBottomNavigationCubit extends Cubit<HomeBottomNavigationState> {
  HomeBottomNavigationCubit() : super(HomeBottomNavigationState());

  void handleIndex(int index) {
    if (index < 0 || index >= HomeBottomNavigationMenu.values.length) return;

    final selected = HomeBottomNavigationMenu.values[index];
    if (selected == state.menu) return;

    emit(state.copyWith(menu: selected));
  }

  void toggleVisibility() {
    emit(state.copyWith(visible: !state.visible));
  }
}
