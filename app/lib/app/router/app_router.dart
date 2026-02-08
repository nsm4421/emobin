import 'package:auto_route/auto_route.dart';
import 'package:emobin/app/pages/entry/entry_screen.dart';
import 'package:emobin/app/pages/splash/splash_screen.dart';
import 'package:feature_auth/feature_auth.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes =>
      [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: EntryRoute.page),
      ];
}
