import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jetu.driver/app/const/app_const.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/services/jetu_auth/grapql_query.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu.driver/app/widgets/app_setting_tile_item.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet_widgets/bottom_sheet_title.dart';
import 'package:jetu.driver/app/widgets/graphql_wrapper/query_wrapper.dart';
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
            dataParser: (json) =>
                JetuDriverModel.fromJson(json, name: 'jetu_drivers_by_pk'),
            contentBuilder: (JetuDriverModel data) {
              return ListTile(
                iconColor: AppColors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minLeadingWidth: 20.0,
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
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: false,
                    builder: (ct) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BottomSheetTitle(title: 'Меню'),
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
                      );
                    },
                  );
                },
              );
            },
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
