import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/resourses/app_icons.dart';
import 'package:jetu.driver/app/view/home/widgets/jetu_map/bloc/jetu_map_cubit.dart';
import 'package:jetu.driver/app/view/home/widgets/jetu_map/bloc/jetu_map_state.dart';
import 'package:jetu.driver/app/widgets/button/menu_button.dart';

class AppBarDefault extends StatelessWidget implements PreferredSizeWidget {
  final bool showMenu;

  const AppBarDefault({Key? key,this.showMenu = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JetuMapCubit, JetuMapState>(
      builder: (context, state) {
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
      },
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(57);
}
