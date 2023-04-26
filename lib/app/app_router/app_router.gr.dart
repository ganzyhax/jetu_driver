// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;

import '../view/account/account_screen.dart' as _i3;
import '../view/auth/login_screen.dart' as _i2;
import '../view/home/home_screen.dart' as _i1;
import '../view/intercity/create/intercity_create_screen.dart' as _i6;
import '../view/intercity/intercity_find_screen.dart' as _i5;
import '../view/intercity/intercity_screen.dart' as _i4;

class AppRouter extends _i7.RootStackRouter {
  AppRouter([_i8.GlobalKey<_i8.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    HomeScreen.name: (routeData) {
      return _i7.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.HomeScreen(),
        transitionsBuilder: _i7.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    LoginScreen.name: (routeData) {
      return _i7.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i2.LoginScreen(),
        transitionsBuilder: _i7.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    AccountScreen.name: (routeData) {
      final args = routeData.argsAs<AccountScreenArgs>();
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i3.AccountScreen(
          key: args.key,
          userId: args.userId,
        ),
      );
    },
    IntercityScreen.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.IntercityScreen(),
      );
    },
    IntercityFindScreen.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.IntercityFindScreen(),
      );
    },
    IntercityCreateScreen.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.IntercityCreateScreen(),
      );
    },
  };

  @override
  List<_i7.RouteConfig> get routes => [
        _i7.RouteConfig(
          HomeScreen.name,
          path: '/',
        ),
        _i7.RouteConfig(
          LoginScreen.name,
          path: '/login-screen',
        ),
        _i7.RouteConfig(
          AccountScreen.name,
          path: '/account-screen',
        ),
        _i7.RouteConfig(
          IntercityScreen.name,
          path: '/intercity-screen',
          children: [
            _i7.RouteConfig(
              IntercityFindScreen.name,
              path: 'intercity-find-screen',
              parent: IntercityScreen.name,
            ),
            _i7.RouteConfig(
              IntercityCreateScreen.name,
              path: 'intercity-create-screen',
              parent: IntercityScreen.name,
            ),
          ],
        ),
      ];
}

/// generated route for
/// [_i1.HomeScreen]
class HomeScreen extends _i7.PageRouteInfo<void> {
  const HomeScreen()
      : super(
          HomeScreen.name,
          path: '/',
        );

  static const String name = 'HomeScreen';
}

/// generated route for
/// [_i2.LoginScreen]
class LoginScreen extends _i7.PageRouteInfo<void> {
  const LoginScreen()
      : super(
          LoginScreen.name,
          path: '/login-screen',
        );

  static const String name = 'LoginScreen';
}

/// generated route for
/// [_i3.AccountScreen]
class AccountScreen extends _i7.PageRouteInfo<AccountScreenArgs> {
  AccountScreen({
    _i8.Key? key,
    required String userId,
  }) : super(
          AccountScreen.name,
          path: '/account-screen',
          args: AccountScreenArgs(
            key: key,
            userId: userId,
          ),
        );

  static const String name = 'AccountScreen';
}

class AccountScreenArgs {
  const AccountScreenArgs({
    this.key,
    required this.userId,
  });

  final _i8.Key? key;

  final String userId;

  @override
  String toString() {
    return 'AccountScreenArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [_i4.IntercityScreen]
class IntercityScreen extends _i7.PageRouteInfo<void> {
  const IntercityScreen({List<_i7.PageRouteInfo>? children})
      : super(
          IntercityScreen.name,
          path: '/intercity-screen',
          initialChildren: children,
        );

  static const String name = 'IntercityScreen';
}

/// generated route for
/// [_i5.IntercityFindScreen]
class IntercityFindScreen extends _i7.PageRouteInfo<void> {
  const IntercityFindScreen()
      : super(
          IntercityFindScreen.name,
          path: 'intercity-find-screen',
        );

  static const String name = 'IntercityFindScreen';
}

/// generated route for
/// [_i6.IntercityCreateScreen]
class IntercityCreateScreen extends _i7.PageRouteInfo<void> {
  const IntercityCreateScreen()
      : super(
          IntercityCreateScreen.name,
          path: 'intercity-create-screen',
        );

  static const String name = 'IntercityCreateScreen';
}
