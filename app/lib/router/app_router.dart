import 'package:auto_route/auto_route.dart';
import 'package:emobin/pages/auth/auth_entry_screen.dart';
import 'package:emobin/pages/auth/sign_in/sign_in_page.dart';
import 'package:emobin/pages/auth/sign_up/sign_up_page.dart';
import 'package:emobin/pages/home/home_screen.dart';
import 'package:emobin/pages/splash/splash_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Screen,Route')
class AppRouter extends RootStackRouter {
  AppRouter({super.navigatorKey});

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: AuthEntryRoute.page),
    CustomRoute(
      page: SignInRoute.page,
      transitionsBuilder: TransitionsBuilders.slideRight,
      duration: Duration(milliseconds: 280),
      reverseDuration: Duration(milliseconds: 280),
    ),
    CustomRoute(
      page: SignUpRoute.page,
      transitionsBuilder: TransitionsBuilders.slideRight,
      duration: Duration(milliseconds: 280),
      reverseDuration: Duration(milliseconds: 280),
    ),
    AutoRoute(page: HomeRoute.page),
  ];
}
