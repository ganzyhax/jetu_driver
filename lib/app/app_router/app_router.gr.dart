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
import 'package:auto_route/auto_route.dart' as _i18;
import 'package:flutter/material.dart' as _i19;

import '../../data/app/app_config.dart' as _i20;
import '../view/account/account_screen.dart' as _i3;
import '../view/add_balance/add_balance_screen.dart' as _i8;
import '../view/add_balance/add_card/add_card_screen.dart' as _i9;
import '../view/auth/forget/forget_password_screen.dart' as _i6;
import '../view/auth/login_screen.dart' as _i2;
import '../view/auth/status/status_screen.dart' as _i5;
import '../view/balance/balance_screen.dart' as _i7;
import '../view/home/home_screen.dart' as _i1;
import '../view/intercity/create/intercity_create_screen.dart' as _i17;
import '../view/intercity/intercity_find_screen.dart' as _i16;
import '../view/intercity/intercity_screen.dart' as _i15;
import '../view/order_history/order_history_screen.dart' as _i10;
import '../view/security/security_screen.dart' as _i12;
import '../view/verification/full_name_screen.dart' as _i13;
import '../view/verification/photo_upload.dart' as _i14;
import '../view/verification/write_us_screen.dart' as _i11;
import '../widgets/remote_config_screen.dart' as _i4;

class AppRouter extends _i18.RootStackRouter {
  AppRouter([_i19.GlobalKey<_i19.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i18.PageFactory> pagesMap = {
    HomeScreen.name: (routeData) {
      return _i18.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i1.HomeScreen(),
        transitionsBuilder: _i18.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    LoginScreen.name: (routeData) {
      return _i18.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i2.LoginScreen(),
        transitionsBuilder: _i18.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    AccountScreen.name: (routeData) {
      final args = routeData.argsAs<AccountScreenArgs>();
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i3.AccountScreen(
          key: args.key,
          userId: args.userId,
        ),
      );
    },
    RemoteConfigScreen.name: (routeData) {
      final args = routeData.argsAs<RemoteConfigScreenArgs>();
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.RemoteConfigScreen(
          key: args.key,
          appConfig: args.appConfig,
        ),
      );
    },
    StatusScreen.name: (routeData) {
      final args = routeData.argsAs<StatusScreenArgs>();
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.StatusScreen(
          key: args.key,
          status: args.status,
        ),
      );
    },
    BalanceScreen.name: (routeData) {
      final args = routeData.argsAs<BalanceScreenArgs>();
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i7.BalanceScreen(
          key: args.key,
          userId: args.userId,
          showBackButton: args.showBackButton,
        ),
      );
    },
    AddBalanceScreen.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i8.AddBalanceScreen(),
      );
    },
    AddCardScreen.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i9.AddCardScreen(),
      );
    },
    OrderHistoryScreen.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i10.OrderHistoryScreen(),
      );
    },
    WriteUsScreen.name: (routeData) {
      final args = routeData.argsAs<WriteUsScreenArgs>();
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i11.WriteUsScreen(
          key: args.key,
          phone: args.phone,
          checkStatus: args.checkStatus,
        ),
      );
    },
    SecurityScreen.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i12.SecurityScreen(),
      );
    },
    FullNameScreen.name: (routeData) {
      return _i18.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i13.FullNameScreen(),
        transitionsBuilder: _i18.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    UploadPhoto.name: (routeData) {
      return _i18.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i14.UploadPhoto(),
        transitionsBuilder: _i18.TransitionsBuilders.noTransition,
        opaque: true,
        barrierDismissible: false,
      );
    },
    IntercityScreen.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i15.IntercityScreen(),
      );
    },
    IntercityFindScreen.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i16.IntercityFindScreen(),
      );
    },
    IntercityCreateScreen.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i17.IntercityCreateScreen(),
      );
    },
  };

  @override
  List<_i18.RouteConfig> get routes => [
        _i18.RouteConfig(
          HomeScreen.name,
          path: '/',
        ),
        _i18.RouteConfig(
          LoginScreen.name,
          path: '/login-screen',
        ),
        _i18.RouteConfig(
          AccountScreen.name,
          path: '/account-screen',
        ),
        _i18.RouteConfig(
          RemoteConfigScreen.name,
          path: '/remote-config-screen',
        ),
        _i18.RouteConfig(
          StatusScreen.name,
          path: '/status-screen',
        ),
        _i18.RouteConfig(
          ForgetPasswordScreen.name,
          path: '/forget-password-screen',
        ),
        _i18.RouteConfig(
          BalanceScreen.name,
          path: '/balance-screen',
        ),
        _i18.RouteConfig(
          AddBalanceScreen.name,
          path: '/add-balance-screen',
        ),
        _i18.RouteConfig(
          AddCardScreen.name,
          path: '/add-card-screen',
        ),
        _i18.RouteConfig(
          OrderHistoryScreen.name,
          path: '/order-history-screen',
        ),
        _i18.RouteConfig(
          WriteUsScreen.name,
          path: '/write-us-screen',
        ),
        _i18.RouteConfig(
          SecurityScreen.name,
          path: '/security-screen',
        ),
        _i18.RouteConfig(
          FullNameScreen.name,
          path: '/full-name-screen',
        ),
        _i18.RouteConfig(
          UploadPhoto.name,
          path: '/upload-photo',
        ),
        _i18.RouteConfig(
          IntercityScreen.name,
          path: '/intercity-screen',
          children: [
            _i18.RouteConfig(
              IntercityFindScreen.name,
              path: 'intercity-find-screen',
              parent: IntercityScreen.name,
            ),
            _i18.RouteConfig(
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
class HomeScreen extends _i18.PageRouteInfo<void> {
  const HomeScreen()
      : super(
          HomeScreen.name,
          path: '/',
        );

  static const String name = 'HomeScreen';
}

/// generated route for
/// [_i2.LoginScreen]
class LoginScreen extends _i18.PageRouteInfo<void> {
  const LoginScreen()
      : super(
          LoginScreen.name,
          path: '/login-screen',
        );

  static const String name = 'LoginScreen';
}

/// generated route for
/// [_i3.AccountScreen]
class AccountScreen extends _i18.PageRouteInfo<AccountScreenArgs> {
  AccountScreen({
    _i19.Key? key,
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

  final _i19.Key? key;

  final String userId;

  @override
  String toString() {
    return 'AccountScreenArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [_i4.RemoteConfigScreen]
class RemoteConfigScreen extends _i18.PageRouteInfo<RemoteConfigScreenArgs> {
  RemoteConfigScreen({
    _i19.Key? key,
    required _i20.AppConfig appConfig,
  }) : super(
          RemoteConfigScreen.name,
          path: '/remote-config-screen',
          args: RemoteConfigScreenArgs(
            key: key,
            appConfig: appConfig,
          ),
        );

  static const String name = 'RemoteConfigScreen';
}

class RemoteConfigScreenArgs {
  const RemoteConfigScreenArgs({
    this.key,
    required this.appConfig,
  });

  final _i19.Key? key;

  final _i20.AppConfig appConfig;

  @override
  String toString() {
    return 'RemoteConfigScreenArgs{key: $key, appConfig: $appConfig}';
  }
}

/// generated route for
/// [_i5.StatusScreen]
class StatusScreen extends _i18.PageRouteInfo<StatusScreenArgs> {
  StatusScreen({
    _i19.Key? key,
    required String status,
  }) : super(
          StatusScreen.name,
          path: '/status-screen',
          args: StatusScreenArgs(
            key: key,
            status: status,
          ),
        );

  static const String name = 'StatusScreen';
}

class StatusScreenArgs {
  const StatusScreenArgs({
    this.key,
    required this.status,
  });

  final _i19.Key? key;

  final String status;

  @override
  String toString() {
    return 'StatusScreenArgs{key: $key, status: $status}';
  }
}

/// generated route for
/// [_i6.ForgetPasswordScreen]
class ForgetPasswordScreen extends _i18.PageRouteInfo<void> {
  const ForgetPasswordScreen()
      : super(
          ForgetPasswordScreen.name,
          path: '/forget-password-screen',
        );

  static const String name = 'ForgetPasswordScreen';
}

/// generated route for
/// [_i7.BalanceScreen]
class BalanceScreen extends _i18.PageRouteInfo<BalanceScreenArgs> {
  BalanceScreen({
    _i19.Key? key,
    required String userId,
    required bool showBackButton,
  }) : super(
          BalanceScreen.name,
          path: '/balance-screen',
          args: BalanceScreenArgs(
            key: key,
            userId: userId,
            showBackButton: showBackButton,
          ),
        );

  static const String name = 'BalanceScreen';
}

class BalanceScreenArgs {
  const BalanceScreenArgs({
    this.key,
    required this.userId,
    required this.showBackButton,
  });

  final _i19.Key? key;

  final String userId;

  final bool showBackButton;

  @override
  String toString() {
    return 'BalanceScreenArgs{key: $key, userId: $userId, showBackButton: $showBackButton}';
  }
}

/// generated route for
/// [_i8.AddBalanceScreen]
class AddBalanceScreen extends _i18.PageRouteInfo<void> {
  const AddBalanceScreen()
      : super(
          AddBalanceScreen.name,
          path: '/add-balance-screen',
        );

  static const String name = 'AddBalanceScreen';
}

/// generated route for
/// [_i9.AddCardScreen]
class AddCardScreen extends _i18.PageRouteInfo<void> {
  const AddCardScreen()
      : super(
          AddCardScreen.name,
          path: '/add-card-screen',
        );

  static const String name = 'AddCardScreen';
}

/// generated route for
/// [_i10.OrderHistoryScreen]
class OrderHistoryScreen extends _i18.PageRouteInfo<void> {
  const OrderHistoryScreen()
      : super(
          OrderHistoryScreen.name,
          path: '/order-history-screen',
        );

  static const String name = 'OrderHistoryScreen';
}

/// generated route for
/// [_i11.WriteUsScreen]
class WriteUsScreen extends _i18.PageRouteInfo<WriteUsScreenArgs> {
  WriteUsScreen({
    _i19.Key? key,
    required String phone,
    bool checkStatus = false,
  }) : super(
          WriteUsScreen.name,
          path: '/write-us-screen',
          args: WriteUsScreenArgs(
            key: key,
            phone: phone,
            checkStatus: checkStatus,
          ),
        );

  static const String name = 'WriteUsScreen';
}

class WriteUsScreenArgs {
  const WriteUsScreenArgs({
    this.key,
    required this.phone,
    this.checkStatus = false,
  });

  final _i19.Key? key;

  final String phone;

  final bool checkStatus;

  @override
  String toString() {
    return 'WriteUsScreenArgs{key: $key, phone: $phone, checkStatus: $checkStatus}';
  }
}

/// generated route for
/// [_i12.SecurityScreen]
class SecurityScreen extends _i18.PageRouteInfo<void> {
  const SecurityScreen()
      : super(
          SecurityScreen.name,
          path: '/security-screen',
        );

  static const String name = 'SecurityScreen';
}

/// generated route for
/// [_i13.FullNameScreen]
class FullNameScreen extends _i18.PageRouteInfo<void> {
  const FullNameScreen()
      : super(
          FullNameScreen.name,
          path: '/full-name-screen',
        );

  static const String name = 'FullNameScreen';
}

/// generated route for
/// [_i14.UploadPhoto]
class UploadPhoto extends _i18.PageRouteInfo<void> {
  const UploadPhoto()
      : super(
          UploadPhoto.name,
          path: '/upload-photo',
        );

  static const String name = 'UploadPhoto';
}

/// generated route for
/// [_i15.IntercityScreen]
class IntercityScreen extends _i18.PageRouteInfo<void> {
  const IntercityScreen({List<_i18.PageRouteInfo>? children})
      : super(
          IntercityScreen.name,
          path: '/intercity-screen',
          initialChildren: children,
        );

  static const String name = 'IntercityScreen';
}

/// generated route for
/// [_i16.IntercityFindScreen]
class IntercityFindScreen extends _i18.PageRouteInfo<void> {
  const IntercityFindScreen()
      : super(
          IntercityFindScreen.name,
          path: 'intercity-find-screen',
        );

  static const String name = 'IntercityFindScreen';
}

/// generated route for
/// [_i17.IntercityCreateScreen]
class IntercityCreateScreen extends _i18.PageRouteInfo<void> {
  const IntercityCreateScreen()
      : super(
          IntercityCreateScreen.name,
          path: 'intercity-create-screen',
        );

  static const String name = 'IntercityCreateScreen';
}
