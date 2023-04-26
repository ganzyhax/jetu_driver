import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/app_navigator.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v1.dart';
import 'package:jetu.driver/app/widgets/text_field_input.dart';

class PasswordScreen extends StatefulWidget {
  final String phone;

  const PasswordScreen({
    Key? key,
    required this.phone,
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
                OtpHeader(address: widget.phone),
                TextFieldInput(
                  hintText: 'пороль',
                  textInputType: TextInputType.text,
                  textEditingController: controller,
                  isPhoneInput: false,
                  autoFocus: true,
                  align: TextAlign.center,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        AppNavigator.navigateToForgetPasswordScreen(
                      context,
                    ),
                    child: const Text('Забыли пороль?'),
                  ),
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: () => context.read<AuthCubit>()
                    ..login(
                      context: context,
                      phone: widget.phone,
                      password: controller.text,
                    ),
                  child: AppButtonV1(
                    isActive: true,
                    isLoading: state.isLoading,
                    text: 'Войти',
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
          'Пороль',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Введите пороль',
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
