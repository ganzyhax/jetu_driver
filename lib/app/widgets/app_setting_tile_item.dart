import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';

class AppSettingTileItem extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  final IconData? icon;
  final bool firstClosePage;

  const AppSettingTileItem({
    Key? key,
    this.onTap,
    this.title,
    this.icon,
    this.firstClosePage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      iconColor: AppColors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      leading: Icon(icon),
      minLeadingWidth: 20.w,
      title: Text(
        title ?? "",
        style: TextStyle(
          color: AppColors.black,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        if (firstClosePage) Navigator.of(context).pop();
        onTap?.call();
      },
    );
  }
}
