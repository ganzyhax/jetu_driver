import 'package:auto_route/auto_route.dart';
import 'package:jetu.driver/app/view/account/account_screen.dart';
import 'package:jetu.driver/app/view/add_balance/add_balance_screen.dart';
import 'package:jetu.driver/app/view/add_balance/add_card/add_card_screen.dart';
import 'package:jetu.driver/app/view/auth/forget/forget_password_screen.dart';
import 'package:jetu.driver/app/view/auth/login_screen.dart';
import 'package:jetu.driver/app/view/auth/status/status_screen.dart';
import 'package:jetu.driver/app/view/auth/verify_screen.dart';
import 'package:jetu.driver/app/view/balance/balance_screen.dart';
import 'package:jetu.driver/app/view/home/home_screen.dart';
import 'package:jetu.driver/app/view/intercity/create/intercity_create_screen.dart';
import 'package:jetu.driver/app/view/intercity/intercity_find_screen.dart';
import 'package:jetu.driver/app/view/intercity/intercity_screen.dart';
import 'package:jetu.driver/app/view/order_history/order_history_screen.dart';
import 'package:jetu.driver/app/view/security/security_screen.dart';
import 'package:jetu.driver/app/view/verification/full_name_screen.dart';
import 'package:jetu.driver/app/view/verification/photo_upload.dart';
import 'package:jetu.driver/app/view/verification/write_us_screen.dart';
import 'package:jetu.driver/app/widgets/remote_config_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Route,Screen',
  routes: <AutoRoute>[
    CustomRoute(
      page: HomeScreen,
      initial: true,
      //guards: [LoginGuard],
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
      page: RemoteConfigScreen,
    ),
    AutoRoute(
      page: StatusScreen,
    ),
    AutoRoute(
      page: BalanceScreen,
    ),
    AutoRoute(
      page: AddBalanceScreen,
    ),
    AutoRoute(
      page: AddCardScreen,
    ),
    AutoRoute(
      page: OrderHistoryScreen,
    ),
    AutoRoute(
      page: WriteUsScreen,
    ),
    AutoRoute(
      page: SecurityScreen,
    ),
    AutoRoute(
      page: VerifyScreen,
    ),
    CustomRoute(
      transitionsBuilder: TransitionsBuilders.noTransition,
      page: FullNameScreen,
    ),
    CustomRoute(
      transitionsBuilder: TransitionsBuilders.noTransition,
      page: UploadPhoto,
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
