import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/extensions/context_extensions.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/resourses/app_icons.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu.driver/app/widgets/app_toast.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v1.dart';
import 'package:jetu.driver/app/widgets/rule_checkbox.dart';
import 'package:jetu.driver/app/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool ruleAgree = true;

  @override
  void initState() {
    _phoneController.addListener(updateState);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state.error.isNotEmpty) {
            AppToast.center(state.error);
          }

          if (state.success) {}
        },
        builder: (context, state) {
          return SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Войти / Регистрация',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: context.sizeScreen.height * 0.025),
                    Row(
                      children: [
                        Container(
                          height: 40.h,
                          width: 65.w,
                          decoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                AppIcons.kzFlag,
                                width: 24.w,
                              ),
                              Text(
                                '+7',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Flexible(
                          child: TextFieldInput(
                            hintText: 'номер телефона',
                            textInputType: TextInputType.phone,
                            textEditingController: _phoneController,
                            isPhoneInput: true,
                            autoFocus: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.sizeScreen.height * 0.025),
                    RuleCheckbox(
                      value: ruleAgree,
                      onTap: (value) => setState(() => ruleAgree = value),
                    ),
                    SizedBox(height: 12.h),
                    GestureDetector(
                      onTap: () {
                        if (!state.isLoading) {
                          context.read<AuthCubit>().checkPhone(
                                context: context,
                                phone: _phoneController.text,
                              );
                        }
                      },
                      child: AppButtonV1(
                        isActive: ruleAgree,
                        isLoading: state.isLoading,
                        text: 'Продолжить',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
