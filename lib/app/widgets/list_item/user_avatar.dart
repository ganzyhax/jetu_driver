import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double size;

  const UserAvatar({Key? key, this.avatarUrl, this.size = 24})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (avatarUrl?.isNotEmpty ?? false) {
      return Image.network(
        avatarUrl ?? '',
        height: size.h,
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.yellow.withOpacity(0.3),
      ),
      child: Icon(
        Ionicons.person,
        size: size.sp,
        color: AppColors.black,
      ),
    );
  }
}
