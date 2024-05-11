import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';

class BottomSheetTitle extends StatelessWidget {
  final String title;
  final bool isLargeTitle;

  const BottomSheetTitle({
    Key? key,
    required this.title,
    this.isLargeTitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
        top: 12.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.black,
              fontSize: isLargeTitle ? 18.sp : 14.sp,
            ),
          ),
          Divider(height: 12.h)
        ],
      ),
    );
  }
}
