import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/app_router/app_router.gr.dart';
import 'package:jetu.driver/app/const/app_const.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/resourses/app_icons.dart';
import 'package:jetu.driver/app/services/functions/phone_verif_func.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu.driver/app/view/auth/verify_screen.dart';
import 'package:jetu.driver/app/widgets/app_toast.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v1.dart';
import 'package:jetu.driver/app/widgets/text_field_input.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class NewPasswordScreen extends StatefulWidget {
  final String? phone;
  const NewPasswordScreen({
    required this.phone,
    Key? key,
  }) : super(key: key);

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  TextEditingController _passController = TextEditingController();
  TextEditingController _pass2Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Придумайте новый пароль',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 48),
                Flexible(
                  child: TextFieldInput(
                    hintText: 'Пароль',
                    textInputType: TextInputType.text,
                    textEditingController: _passController,
                    isPass: true,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: TextFieldInput(
                    hintText: 'Повторите пароль',
                    textInputType: TextInputType.text,
                    textEditingController: _pass2Controller,
                    isPass: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () async {
                if (_passController.text == _pass2Controller.text) {
                  bool success = await context.read<AuthCubit>().resetPassword(
                      context: context,
                      phone: widget.phone.toString(),
                      password: _passController.text);
                  if (success) {
                    await context.router.pushAndPopUntil(
                      const HomeScreen(),
                      predicate: (Route<dynamic> route) => false,
                    );
                  }
                } else {
                  AppToast.center('Пароли не совпадают!');
                }
              },
              child: AppButtonV1(
                isActive: true,
                text: 'Далее',
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
