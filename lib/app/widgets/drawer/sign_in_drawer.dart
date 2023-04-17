import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jetu.driver/app/app_navigator.dart';
import 'package:jetu.driver/app/app_router/app_router.gr.dart';
import 'package:jetu.driver/app/const/app_const.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/services/jetu_auth/grapql_query.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu.driver/app/widgets/app_setting_tile_item.dart';
import 'package:jetu.driver/app/widgets/graphql_wrapper/query_wrapper.dart';
import 'package:jetu.driver/app/widgets/verified.dart';
import 'package:jetu.driver/data/model/jetu_driver_model.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInDrawer extends StatelessWidget {
  final String userId;

  const SignInDrawer({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          QueryWrapper<JetuDriverModel>(
            queryString: JetuAuthQuery.fetchUserInfo(),
            variables: {"userId": userId},
            dataParser: (json) => JetuDriverModel.fromJson(
              json,
              name: 'jetu_drivers_by_pk',
            ),
            contentBuilder: (JetuDriverModel data) {
              return ListTile(
                iconColor: AppColors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minLeadingWidth: 1.0,
                leading: VerifiedIcon(
                  isVerified: data.isVerified ?? false,
                ),
                horizontalTitleGap: 5,
                title: Text(
                  '${data.name ?? 'Пусто'} ${data.surname ?? ''}',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  data.phone ?? 'Не указан',
                  style: TextStyle(
                    color: AppColors.black.withOpacity(0.6),
                    fontSize: 12.sp,
                  ),
                ),
                onTap: () async {
                  context.router.push(
                    AccountScreen(
                      userId: userId,
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(height: 24.h),
          // AppSettingTileItem(
          //   onTap: () => AppNavigator.navigateToOrderHistory(context),
          //   icon: Ionicons.car_outline,
          //   title: 'История заказов',
          // ),
          AppSettingTileItem(
            onTap: () => context.router.push(
              const IntercityScreen(),
            ),
            icon: Ionicons.globe_outline,
            title: 'Межгород',
          ),
          const Spacer(),
          AppSettingTileItem(
            onTap: () => launchUrl(Uri.parse(AppConst.instagramAppSupport)),
            icon: Ionicons.information,
            title: 'О нас',
          ),
          AppSettingTileItem(
            onTap: () => launchUrl(Uri.parse(AppConst.whatsAppSupport)),
            icon: Ionicons.help_outline,
            title: 'Служба поддержки',
          ),
          AppSettingTileItem(
            onTap: () => context.read<AuthCubit>().logout(context),
            icon: Ionicons.log_out_outline,
            title: 'Выйти',
          ),
        ],
      ),
    );
  }
}
