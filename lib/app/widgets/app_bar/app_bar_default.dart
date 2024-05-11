import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/resourses/app_icons.dart';
import 'package:jetu.driver/app/widgets/button/menu_button.dart';

class AppBarDefault extends StatelessWidget implements PreferredSizeWidget {
  final bool showMenu;

  const AppBarDefault({Key? key, this.showMenu = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showMenu ? const MenuButton() : SizedBox(width: 24.w),
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              AppIcons.jetuLogo,
              height: 36.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            'Pro',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 52.w),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(57);
}

class AppBarBack extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const AppBarBack({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          elevation: 0,
          backgroundColor: AppColors.white,
          title: title != null
              ? Text(
                  title ?? '',
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : null,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.black,
            ),
          ),
        ),
        const Divider(
          height: 0,
          color: AppColors.black,
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(74);
}
