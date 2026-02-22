import 'package:auto_route/auto_route.dart';
import 'package:emobin/features/auth/entry/pg_auth_entry.dart';
import 'package:emobin/features/auth/validate_password/pg_validate_password.dart';
import 'package:emobin/features/auth/sign_in/pg_sign_in.dart';
import 'package:emobin/features/auth/sign_up/pg_sign_up.dart';
import 'package:emobin/features/entry/root/pg_entry.dart';
import 'package:emobin/features/entry/feed/pg_display_feed_entry.dart';
import 'package:emobin/features/entry/home/pg_home_entry.dart';
import 'package:emobin/features/entry/setting/pg_setting_entry.dart';
import 'package:emobin/features/feed/create/pg_create_feed.dart';
import 'package:emobin/features/feed/detail/pg_feed_detail.dart';
import 'package:emobin/features/feed/edit/pg_edit_feed.dart';
import 'package:emobin/features/feed/hashtag/pg_edit_hashtag.dart';
import 'package:emobin/features/feed/sync/pg_feed_sync.dart';
import 'package:emobin/features/feed/trash/pg_feed_trash.dart';
import 'package:emobin/features/splash/pg_splash.dart';
import 'package:feature_setting/feature_setting.dart';
import 'package:flutter/material.dart' show Key;

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter({super.navigatorKey});

  static const Duration _transitionDuration = Duration(milliseconds: 280);

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    ..._authRoutes,
    _homeRoute,
    _securityRoute,
    ..._feedRoutes,
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

  Iterable<AutoRoute> get _feedRoutes => [
    CustomRoute(
      page: CreateFeedRoute.page,
      transitionsBuilder: TransitionsBuilders.slideRight,
      duration: _transitionDuration,
      reverseDuration: _transitionDuration,
    ),
    CustomRoute(
      page: EditFeedRoute.page,
      transitionsBuilder: TransitionsBuilders.slideRight,
      duration: _transitionDuration,
      reverseDuration: _transitionDuration,
    ),
    CustomRoute(
      page: FeedDetailRoute.page,
      transitionsBuilder: TransitionsBuilders.slideRight,
      duration: _transitionDuration,
      reverseDuration: _transitionDuration,
    ),
    CustomRoute(
      page: EditHashtagRoute.page,
      transitionsBuilder: TransitionsBuilders.slideRight,
      duration: _transitionDuration,
      reverseDuration: _transitionDuration,
    ),
    CustomRoute(
      page: FeedSyncRoute.page,
      transitionsBuilder: TransitionsBuilders.slideRight,
      duration: _transitionDuration,
      reverseDuration: _transitionDuration,
    ),
    CustomRoute(
      page: FeedTrashRoute.page,
      transitionsBuilder: TransitionsBuilders.slideRight,
      duration: _transitionDuration,
      reverseDuration: _transitionDuration,
    ),
  ];
}
