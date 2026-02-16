import 'package:auto_route/auto_route.dart';
import 'package:emobin/pages/auth/auth_entry_screen.dart';
import 'package:emobin/pages/auth/security/validate_password_screen.dart';
import 'package:emobin/pages/auth/sign_in/sign_in_page.dart';
import 'package:emobin/pages/auth/sign_up/sign_up_page.dart';
import 'package:emobin/pages/entry/entry_screen.dart';
import 'package:emobin/pages/entry/feed/feed_entry_page.dart';
import 'package:emobin/pages/entry/home/home_screen.dart';
import 'package:emobin/pages/entry/setting/setting_entry_screen.dart';
import 'package:emobin/pages/splash/splash_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Screen,Route')
class AppRouter extends RootStackRouter {
  AppRouter({super.navigatorKey});

  static const Duration _transitionDuration = Duration(milliseconds: 280);

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    ..._authRoutes,
    _homeRoute,
    _securityRoute,
  ];

  Iterable<AutoRoute> get _authRoutes => [
    AutoRoute(page: AuthEntryRoute.page),
    CustomRoute(
      page: SignInRoute.page,
      transitionsBuilder: TransitionsBuilders.slideRight,
      duration: _transitionDuration,
      reverseDuration: _transitionDuration,
    ),
    CustomRoute(
      page: SignUpRoute.page,
      transitionsBuilder: TransitionsBuilders.slideRight,
      duration: _transitionDuration,
      reverseDuration: _transitionDuration,
    ),
  ];

  AutoRoute get _homeRoute => AutoRoute(
    page: EntryRoute.page,
    children: [
      AutoRoute(page: HomeEntryRoute.page),
      AutoRoute(page: FeedEntryRoute.page),
      AutoRoute(page: SettingEntryRoute.page),
    ],
  );

  AutoRoute get _securityRoute => AutoRoute(page: ValidatePasswordRoute.page);
}
