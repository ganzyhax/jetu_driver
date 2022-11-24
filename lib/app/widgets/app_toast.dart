import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';

class AppToast {
  static void center(String? text) async {
    Fluttertoast.showToast(
      msg: text ?? '',
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: AppColors.black.withOpacity(0.4),
      gravity: ToastGravity.CENTER,
      textColor: Colors.white,
      fontSize: 16.0.sp,
    );
  }
}
