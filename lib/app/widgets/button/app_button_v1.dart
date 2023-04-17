import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/widgets/app_loader.dart';

class AppButtonV1 extends StatelessWidget {
  final double? height;
  final bool isActive;
  final bool isLoading;
  final String text;
  final TextStyle? textStyle;
  final Color? bgColor;

  const AppButtonV1({
    Key? key,
    this.height,
    this.isActive = true,
    this.isLoading = false,
    required this.text,
    this.textStyle,
    this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 46.h,
      decoration: BoxDecoration(
        color: isActive
            ? bgColor ?? AppColors.blue
            : bgColor?.withOpacity(0.6) ?? AppColors.blue.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            const AppLoader()
          else
            Text(
              text,
              textAlign: TextAlign.center,
              style: textStyle ??
                  TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
            ),
        ],
      ),
    );
  }
}
