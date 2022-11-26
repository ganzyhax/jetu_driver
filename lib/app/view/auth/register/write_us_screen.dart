import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/const/app_const.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v1.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class WriteUsScreen extends StatelessWidget {
  const WriteUsScreen({Key? key}) : super(key: key);

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
            OtpHeader(),
            Lottie.asset(
              'assets/lottie/doc_verification.json',
              repeat: false,
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: () => launchUrl(
                Uri.parse(AppConst.whatsAppSupport),
              ).then((value) => Navigator.of(context).pop(false)),
              child: AppButtonV1(
                isActive: true,
                text: 'Написать Ватсап',
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
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
        Text(
          'Верификация',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Для регистрации как водитель напишите нам Ватсап',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.black.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
