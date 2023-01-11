import 'package:auto_route/auto_route.dart';
import 'package:jetu.driver/app/view/home/home_screen.dart';
import 'package:jetu.driver/app/view/intercity/create/intercity_create_screen.dart';
import 'package:jetu.driver/app/view/intercity/intercity_find_screen.dart';
import 'package:jetu.driver/app/view/intercity/intercity_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Route,Screen',
  routes: <AutoRoute>[
    AutoRoute(
      page: HomeScreen,
      initial: true,
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
