import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jetu.driver/app/di/injection.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu.driver/app/view/auth/forget/forget_password_screen.dart';
import 'package:jetu.driver/app/view/auth/login_screen.dart';
import 'package:jetu.driver/app/view/auth/register/full_name_screen.dart';
import 'package:jetu.driver/app/view/auth/register/write_us_screen.dart';
import 'package:jetu.driver/app/view/auth/status/status_screen.dart';
import 'package:jetu.driver/app/view/auth/verify_screen.dart';
import 'package:jetu.driver/app/view/balance/balance_screen.dart';
import 'package:jetu.driver/app/view/home/home_screen.dart';
import 'package:jetu.driver/app/view/intercity/intercity_screen.dart';
import 'package:jetu.driver/app/view/order_history/order_history_screen.dart';
import 'package:jetu.driver/app/widgets/remote_config_screen.dart';
import 'package:jetu.driver/data/app/app_config.dart';

class AppNavigator {
  static navigateToHome(BuildContext context) async {
    _pushAndRemoveUntilPage(
      context,
      const HomeScreen(),
    );
  }

  static navigateToLogin(BuildContext context) {
    _pushReplacement(
      context,
      const LoginScreen(),
    );
  }

  static navigateToStatus(BuildContext context, {required String status}) {
    _pushReplacement(
      context,
      StatusScreen(status: status),
    );
  }

  static navigateToRemoteConfig(BuildContext context,
      {required AppConfig appConfig}) {
    _pushReplacement(
      context,
      RemoteConfigScreen(appConfig: appConfig),
    );
  }

  static navigateToPhoneVerification(
    BuildContext context, {
    required String phone,
    required String verificationId,
  }) {
    _pushToPage(
      context,
      BlocProvider(
        create: (context) => AuthCubit(client: injection()),
        child: VerifyScreen(
          phone: phone,
          verificationId: verificationId,
        ),
      ),
    );
  }

  static navigateToRegister(
    BuildContext context, {
    required String userId,
    required String phone,
  }) {
    _pushReplacement(
      context,
      FullNameScreen(userId: userId, phone: phone),
    );
  }

  static navigateToRegisterToWrite(
    BuildContext context, {
    required String title,
    required String desc,
  }) {
    _pushToPage(
      context,
      const WriteUsScreen(),
    );
  }

  static navigateToForgetPasswordScreen(BuildContext context) {
    _pushToPage(
      context,
      const ForgetPasswordScreen(),
    );
  }

  static navigateToOrderHistory(BuildContext context) {
    _pushToPage(
      context,
      const OrderHistoryScreen(),
    );
  }

  static navigateToBalance(
    BuildContext context, {
    required String userId,
    bool showBackButton = true,
  }) {
    _pushToPage(
      context,
      BalanceScreen(userId: userId,showBackButton: showBackButton),
    );
  }

  static navigateToInterCity(BuildContext context) {
    _pushToPage(
      context,
      const IntercityScreen(),
    );
  }

  static _pushToPage(BuildContext context, Widget page,
      {bool showFullPage = true}) {
    return Navigator.of(context, rootNavigator: showFullPage).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  static _pushReplacement(BuildContext context, Widget page) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  static _pushAndRemoveUntilPage(BuildContext context, Widget page) {
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
      (route) => false,
    );
  }

  static _pushAndRemoveUntilNoAnimationPage(BuildContext context, Widget page) {
    return Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(pageBuilder: (_, __, ___) => page),
      (route) => false,
    );
  }
}
