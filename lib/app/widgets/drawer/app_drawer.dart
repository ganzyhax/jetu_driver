import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jetu.driver/app/view/auth/banned/banned_screen.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu.driver/app/view/auth/status/status_screen.dart';
import 'package:jetu.driver/app/widgets/drawer/sign_in_drawer.dart';
import 'package:jetu.driver/app/widgets/drawer/sign_out_drawer.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
        if (state.isLogged) {
          log('APP DRAWER STATUS ' + state.status);
          if (state.status == 'approved') {
            return SignInDrawer(userId: state.userId);
          } else if (state.status == 'banned') {
            return BannedScreen(status: state.status);
          } else {
            return StatusScreen(status: state.status);
          }
        } else {
          return SignOutDrawer();
        }
      }),
    );
  }
}
