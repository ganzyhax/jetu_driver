import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/app_router/app_router.gr.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/services/functions/phone_verif_func.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu.driver/app/view/auth/forget/forget_password_screen.dart';
import 'package:jetu.driver/app/widgets/app_bar/app_bar_default.dart';
import 'package:jetu.driver/app/widgets/app_toast.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v1.dart';
import 'package:auto_route/auto_route.dart';
import 'package:pinput/pinput.dart';

class VerifyScreen extends StatefulWidget {
  final String phone;
  final String pinCode;
  final bool? isFrogetPassword;
  const VerifyScreen(
      {Key? key,
      required this.phone,
      required this.pinCode,
      this.isFrogetPassword})
      : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  static const maxTime = 3 * 60; // 3 минуты в секундах
  int remainingTime = maxTime;
  Timer? _timer;
  bool isSms = false;

  void startTimer() {
    _timer?.cancel(); // Отменяем предыдущий таймер, если он был запущен
    remainingTime = maxTime; // Сбрасываем время до начального значения
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        setState(() {
          isSms = true;
        });

        _timer?.cancel();
      }
    });
  }

  String formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  bool showError = false;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: AppColors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey),
      ),
    );

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const AppBarBack(),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OtpHeader(address: widget.phone),
                SizedBox(
                  height: 68.h,
                  child: Pinput(
                    length: 6,
                    controller: controller,
                    focusNode: focusNode,
                    autofocus: true,
                    defaultPinTheme: defaultPinTheme,
                    onCompleted: (code) async {
                      if (widget.pinCode == code) {
                        if (widget.isFrogetPassword == true) {
                          // await context.router.pushAndPopUntil(
                          //   const HomeScreen(),
                          //   predicate: (Route<dynamic> route) => false,
                          // );

                          Navigator.of(context).push(
                              new MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) {
                            return NewPasswordScreen(
                              phone: widget.phone,
                            );
                          }));
                        } else {
                          Navigator.of(context).pop(true);
                        }
                      } else {
                        AppToast.center('Не правильный пин код!');
                      }
                    },
                    focusedPinTheme: defaultPinTheme.copyWith(
                      height: 68.h,
                      width: 64.w,
                    ),
                    errorPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Не получили код? ',
                        style: TextStyle(
                          color: Color(0xFF121212),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.44,
                        ),
                      ),
                      TextSpan(
                        text: (isSms == true)
                            ? 'Отправить еще раз'
                            : formatTime(remainingTime),
                        style: TextStyle(
                          color: Color(0xFF1D26FD),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.44,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 36.h),
                AppButtonV1(
                  isActive: true,
                  isLoading: state.isLoading,
                  text: 'Отправить',
                ),
                SizedBox(height: 24.h),
                Center(
                  child: Text(
                    'SMS с кодом доставляется до 3 минут.',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class OtpHeader extends StatelessWidget {
  final String address;

  const OtpHeader({Key? key, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Забыли пароль?',
          style: TextStyle(
            fontSize: 24.sp,
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Введите код, отправленный на номер',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '+7 $address',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 64)
      ],
    );
  }
}
