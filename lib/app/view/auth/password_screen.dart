import 'dart:math';
import 'dart:developer' as logdev;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/app_router/app_router.gr.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/services/functions/phone_verif_func.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu.driver/app/view/auth/verify_screen.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v1.dart';
import 'package:jetu.driver/app/widgets/text_field_input.dart';

class PasswordScreen extends StatefulWidget {
  final String phone;
  final bool isNewUser;

  const PasswordScreen({
    Key? key,
    required this.phone,
    required this.isNewUser,
  }) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.white,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                color: AppColors.black,
              ),
            ),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OtpHeader(
                  address: widget.phone,
                  isNewUser: widget.isNewUser,
                ),
                TextFieldInput(
                  hintText: 'Пароль',
                  textInputType: TextInputType.text,
                  textEditingController: controller,
                  isPass: true,
                  isPhoneInput: false,
                  autoFocus: true,
                  align: TextAlign.center,
                ),
                if (!widget.isNewUser)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        final Random random = Random();
                        int pinCode = random.nextInt(900000) + 100000;
                        logdev.log(pinCode.toString());

                        await PhoneVerification().sendVerificationCode(
                          generatedCode: pinCode.toString(),
                          phoneNumber:
                              '+7' + widget.phone.replaceAll(RegExp(r'\D'), ''),
                        );

                        Navigator.of(context).push(
                            new MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) {
                          return VerifyScreen(
                            isFrogetPassword: true,
                            phone: widget.phone,
                            pinCode: pinCode.toString(),
                          );
                        }));
                      },
                      child: const Text('Забыли пароль?'),
                    ),
                  ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: () async {
                    if (!widget.isNewUser) {
                      context.read<AuthCubit>().login(
                            context: context,
                            phone: widget.phone,
                            password: controller.text,
                          );
                    } else {
                      context.read<AuthCubit>().savePassword(
                            widget.phone,
                            controller.text,
                            context,
                          );
                    }
                  },
                  child: AppButtonV1(
                    isActive: true,
                    isLoading: state.isLoading,
                    text: widget.isNewUser ? "Дальше" : 'Войти',
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
  final bool isNewUser;

  const OtpHeader({
    Key? key,
    required this.address,
    required this.isNewUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          isNewUser ? 'Придумайте новый пароль' : "Пароль",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Введите пароль',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.black.withOpacity(0.67),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '+7 $address',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.black.withOpacity(0.67),
          ),
        ),
        const SizedBox(height: 64)
      ],
    );
  }
}
