import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jetu.driver/app/app_navigator.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/services/jetu_auth/grapql_query.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu.driver/app/widgets/app_setting_tile_item.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet_widgets/bottom_sheet_title.dart';
import 'package:jetu.driver/app/widgets/graphql_wrapper/query_wrapper.dart';
import 'package:jetu.driver/app/widgets/verified.dart';
import 'package:jetu.driver/data/model/jetu_driver_model.dart';

class AccountScreen extends StatelessWidget {
  final String userId;

  const AccountScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        title: const Text(
          'Мой аккаунт',
          style: TextStyle(
            color: AppColors.black,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(false),
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: false,
                builder: (ct) {
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const BottomSheetTitle(title: 'Меню'),
                        AppSettingTileItem(
                          onTap: () {
                            showDialog(
                              context: ct,
                              builder: (BuildContext ncontext) {
                                return AlertDialog(
                                  title: const Text("Удаление аккаунта"),
                                  content: const Text(
                                      "Вы уверены, что хотите удалить свой аккаунт? Вы можете снова войти в систему в течение 30 дней, чтобы восстановить учетную запись. По истечении этого периода ваши данные будут полностью удалены."),
                                  actions: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: TextButton(
                                            onPressed: () => context
                                                .read<AuthCubit>()
                                                .logout(context),
                                            child: const Text(
                                              "Удалить аккаунт",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                color: Color(0xffb20d0e),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text(
                                            "Отмена",
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Ionicons.trash_outline,
                          title: 'Удалить аккаунт',
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(
              Icons.menu,
              color: AppColors.black,
            ),
          )
        ],
      ),
      body: Column(
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
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerifiedIcon(
                    isVerified: data.isVerified ?? false,
                  ),
                  SizedBox(width: 5.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${data.name ?? 'Пусто'} ${data.surname ?? ''}',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        data.phone ?? 'Не указан',
                        style: TextStyle(
                          color: AppColors.black.withOpacity(0.6),
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 24.w),
                ],
              );
            },
          ),
          SizedBox(height: 12.h),
          AppSettingTileItem(
            firstClosePage: false,
            onTap: () => AppNavigator.navigateToBalance(
              context,
              userId: userId,
            ),
            icon: Ionicons.cash_outline,
            title: 'Мой баланс',
          ),
        ],
      ),
    );
  }
}
