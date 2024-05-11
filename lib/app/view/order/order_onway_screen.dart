import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jetu.driver/app/extensions/context_extensions.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/services/functions/notification_func.dart';
import 'package:jetu.driver/app/view/order/bloc/order_cubit.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet/app_detail_sheet.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet_widgets/bottom_sheet_title.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet_widgets/external_maps.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet_widgets/order_options.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v1.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v2.dart';
import 'package:jetu.driver/app/widgets/button/light_colored_button.dart';
import 'package:jetu.driver/app/widgets/list_item/order_item.dart';
import 'package:jetu.driver/data/model/jetu_order_model.dart';
import 'package:map_launcher/map_launcher.dart';

class OrderOnWayScreen extends StatelessWidget {
  final JetuOrderModel model;

  const OrderOnWayScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      maxHeight: 0.462,
      panel: Container(
        color: AppColors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
          ),
          child: Column(
            children: [
              OrderItem(
                model: model,
                showPhone: true,
              ),
              LightColoredButton(
                icon: Ionicons.options,
                text: "Опция",
                onPressed: () => AppDetailSheet.open(
                  context,
                  widget: OrderOptions(model: model),
                ),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () {
                  context.read<OrderCubit>().changeStatusOrder(
                        model.id,
                        status: 'arrived',
                      );
                  NotificationHelper().sendPushNotification(
                      model.user!.token.toString(),
                      'Jetu',
                      'Водитель ждет вас!');
                },
                child: const AppButtonV1(
                  text: 'Я здесь',
                ),
              ),
              SizedBox(height: 6.h),
              GestureDetector(
                onTap: () async => AppDetailSheet.open(
                  context,
                  widget: ExternalMaps(
                    maps: await MapLauncher.installedMaps,
                    location: model.aPoint(),
                  ),
                ),
                child: const AppButtonV2(
                  text: 'Навигация',
                ),
              ),
              // // const Spacer(),
              // const BottomSheetTitle(
              //   title:
              //       'Пользователь получит уведомление, как только вы нажмете «Прибыл»',
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
