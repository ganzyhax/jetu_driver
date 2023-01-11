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
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;

import '../view/home/home_screen.dart' as _i1;
import '../view/intercity/create/intercity_create_screen.dart' as _i4;
import '../view/intercity/intercity_find_screen.dart' as _i3;
import '../view/intercity/intercity_screen.dart' as _i2;

class AppRouter extends _i5.RootStackRouter {
  AppRouter([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    HomeScreen.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.HomeScreen(),
      );
    },
    IntercityScreen.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.IntercityScreen(),
      );
    },
    IntercityFindScreen.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.IntercityFindScreen(),
      );
    },
    IntercityCreateScreen.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.IntercityCreateScreen(),
      );
    },
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(
          HomeScreen.name,
          path: '/',
        ),
        _i5.RouteConfig(
          IntercityScreen.name,
          path: '/intercity-screen',
          children: [
            _i5.RouteConfig(
              IntercityFindScreen.name,
              path: 'intercity-find-screen',
              parent: IntercityScreen.name,
            ),
            _i5.RouteConfig(
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
class HomeScreen extends _i5.PageRouteInfo<void> {
  const HomeScreen()
      : super(
          HomeScreen.name,
          path: '/',
        );

  static const String name = 'HomeScreen';
}

/// generated route for
/// [_i2.IntercityScreen]
class IntercityScreen extends _i5.PageRouteInfo<void> {
  const IntercityScreen({List<_i5.PageRouteInfo>? children})
      : super(
          IntercityScreen.name,
          path: '/intercity-screen',
          initialChildren: children,
        );

  static const String name = 'IntercityScreen';
}

/// generated route for
/// [_i3.IntercityFindScreen]
class IntercityFindScreen extends _i5.PageRouteInfo<void> {
  const IntercityFindScreen()
      : super(
          IntercityFindScreen.name,
          path: 'intercity-find-screen',
        );

  static const String name = 'IntercityFindScreen';
}

/// generated route for
/// [_i4.IntercityCreateScreen]
class IntercityCreateScreen extends _i5.PageRouteInfo<void> {
  const IntercityCreateScreen()
      : super(
          IntercityCreateScreen.name,
          path: 'intercity-create-screen',
        );

  static const String name = 'IntercityCreateScreen';
}
