import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jetu.driver/app/app_router/app_router.gr.dart';
import 'package:jetu.driver/app/const/app_const.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/services/jetu_auth/grapql_query.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu.driver/app/widgets/graphql_wrapper/query_wrapper.dart';
import 'package:jetu.driver/data/model/jetu_driver_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../resourses/app_icons.dart';

class SignInDrawer extends StatelessWidget {
  final String userId;

  const SignInDrawer({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(
      color: AppColors.black,
      fontSize: 16,
      fontWeight: FontWeight.w300,
    );

    return SafeArea(
      minimum: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              print(data.avatarUrl.toString() + ' sdasdasdsad');
              return ListTile(
                iconColor: AppColors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minLeadingWidth: 1.0,
                leading: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: (data.avatarUrl == null)
                        ? Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: const Color(0xff7c94b6),
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/images/jetu_logo.jpeg"),
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                            ),
                          )
                        : Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: const Color(0xff7c94b6),
                              image: DecorationImage(
                                image: NetworkImage(data.avatarUrl.toString()),
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                            ),
                          )),
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
                  'Ваш баланс: ' + data.amount.toStringAsFixed(0) + ' ₸',
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
          ListTile(
            iconColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: Icon(Icons.home_work_outlined),
            onTap: () {
              Navigator.pop(context);
            },
            title: Text(
              'Город',
              style: textStyle,
            ),
          ),
          ListTile(
            iconColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: SvgPicture.asset(
              AppIcons.intercityIcon,
            ),
            title: Text(
              'Межгород',
              style: textStyle,
            ),
            onTap: () => context.router.push(
              const IntercityScreen(),
            ),
          ),
          ListTile(
            iconColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: SvgPicture.asset(
              AppIcons.historyIcon,
            ),
            title: Text(
              'История заказов',
              style: textStyle,
            ),
            onTap: () => context.router.push(
              const OrderHistoryScreen(),
            ),
          ),
          ListTile(
            iconColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: SvgPicture.asset(
              AppIcons.balanceIcon,
            ),
            title: Text(
              'Мой баланс',
              style: textStyle,
            ),
            onTap: () => context.router.push(
              BalanceScreen(
                userId: userId,
                showBackButton: true,
              ),
            ),
          ),
          ListTile(
            iconColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: Image.asset(
              AppIcons.securityIcon,
              height: 24,
              width: 24,
            ),
            title: Text(
              'Безопасность',
              style: textStyle,
            ),
            onTap: () => context.router.push(
              const SecurityScreen(),
            ),
          ),
          ListTile(
            iconColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: SvgPicture.asset(
              AppIcons.aboutIcon,
            ),
            title: Text(
              'О нас',
              style: textStyle,
            ),
            onTap: () => launchUrl(Uri.parse(AppConst.instagramAppSupport)),
          ),
          ListTile(
            iconColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: SvgPicture.asset(
              AppIcons.helpIcon,
            ),
            title: Text(
              'Служба поддержки',
              style: textStyle,
            ),
            onTap: () => launchUrl(Uri.parse(AppConst.whatsAppSupport)),
          ),
          ListTile(
            iconColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: Image.asset(
              AppIcons.privacyIcon,
              height: 21,
            ),
            title: Text(
              'Политика конфиденциальности',
              style: textStyle,
            ),
            onTap: () async => await launchUrl(
              Uri.parse('https://jetutaxi.kz/privacy-policy/ '),
            ),
          ),
          ListTile(
            iconColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: SvgPicture.asset(
              AppIcons.logoutIcon,
            ),
            title: Text(
              'Выйти',
              style: textStyle,
            ),
            onTap: () => context.read<AuthCubit>().logout(context),
          ),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
