import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/app_router/app_router.gr.dart';
import 'package:jetu.driver/app/const/app_const.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu.driver/app/view/verification/bloc/verification_cubit.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v1.dart';
import 'package:url_launcher/url_launcher.dart';

class WriteUsScreen extends StatelessWidget {
  final String phone;
  final bool checkStatus;

  const WriteUsScreen({
    Key? key,
    required this.phone,
    this.checkStatus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: GestureDetector(
          onTap: () async {
            if (checkStatus) {
              await context.router.pushAndPopUntil(
                const HomeScreen(),
                predicate: (Route<dynamic> route) => false,
              );
            } else {
              context.router.pop();
            }
          },
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              checkStatus ? const OtpHeader() : const OtpHeaderV1(),
              SizedBox(height: 12.h),
              Image.asset(
                'assets/images/verification_1.png',
                // repeat: false,
              ),
              SizedBox(height: 12.h),
              if (checkStatus)
                Text(
                  'Ожидайте ответа в течение 24 часа!\nПосле проверок вам будет начислен 2000 тенге в бонусах',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              const Spacer(),
              if (!checkStatus)
                GestureDetector(
                  onTap: () {
                    if (checkStatus) {
                      launchUrl(
                        Uri.parse(AppConst.whatsAppSupport),
                      );
                    } else {
                      context.read<VerificationCubit>().setPhone(phone);
                      context.router.popAndPush(
                        const FullNameScreen(),
                      );
                    }
                  },
                  child: AppButtonV1(
                    isActive: true,
                    text: checkStatus ? 'Написать' : 'Начать',
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class OtpHeaderV1 extends StatelessWidget {
  const OtpHeaderV1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Верификация',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Для регистрации в качестве водителя необходимо пройти пару шагов',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.black.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class OtpHeader extends StatelessWidget {
  const OtpHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 12.h),
        Text(
          'Ваши документы находятся на рассмотрении',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
