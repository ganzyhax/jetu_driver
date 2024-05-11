import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/app_router/app_router.gr.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu.driver/app/widgets/app_bar/app_bar_default.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v1.dart';
import 'package:jetu.driver/app/widgets/drawer/app_drawer.dart';

class BannedScreen extends StatelessWidget {
  final String status;

  const BannedScreen({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarDefault(),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            pendingWidget(context),
          ],
        ),
      ),
    );
  }

  Widget pendingWidget(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == 'approved') {
          context.router.pushAndPopUntil(
            const HomeScreen(),
            predicate: (Route<dynamic> route) => false,
          );
          // AppNavigator.navigateToHome(context);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24.h),
              Text(
                'Ваш аккаунт забанен!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.red,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Напишите администрации Jetu.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 36.h),
              GestureDetector(
                onTap: () => context.read<AuthCubit>().checkStatus(),
                child: AppButtonV1(
                  isLoading: state.isLoading,
                  text: 'Проверить статус',
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
