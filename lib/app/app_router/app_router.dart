import 'package:auto_route/auto_route.dart';
import 'package:jetu.driver/app/view/account/account_screen.dart';
import 'package:jetu.driver/app/view/auth/login_screen.dart';
import 'package:jetu.driver/app/view/home/home_screen.dart';
import 'package:jetu.driver/app/view/intercity/create/intercity_create_screen.dart';
import 'package:jetu.driver/app/view/intercity/intercity_find_screen.dart';
import 'package:jetu.driver/app/view/intercity/intercity_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Route,Screen',
  routes: <AutoRoute>[
    CustomRoute(
      page: HomeScreen,
      initial: true,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),
    CustomRoute(
      page: LoginScreen,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),
    AutoRoute(
      page: AccountScreen,
    ),
    AutoRoute(
      page: IntercityScreen,
      children: [
        AutoRoute(
          page: IntercityFindScreen,
        ),
        AutoRoute(
          page: IntercityCreateScreen,
        ),
      ],
    ),
  ],
)
class $AppRouter {}
