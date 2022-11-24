import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/view/order/bloc/order_cubit.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet/app_detail_sheet.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet_widgets/bottom_sheet_title.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet_widgets/external_maps.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v1.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v2.dart';
import 'package:jetu.driver/app/widgets/list_item/order_item.dart';
import 'package:jetu.driver/data/model/jetu_order_model.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class OrderStartedScreen extends StatelessWidget {
  final PanelController panelController;
  final JetuOrderModel model;

  const OrderStartedScreen({
    Key? key,
    required this.panelController,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      panelController: panelController,
      panel: Container(
        child: Column(
          children: [
            BottomSheetTitle(
              title: 'Направление к месту назначение',
            ),
            OrderItem(
              model: model,
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: () async => AppDetailSheet.open(
                context,
                widget: ExternalMaps(
                  maps: await MapLauncher.installedMaps,
                  location: model.aPoint(),
                ),
              ),
              child: AppButtonV2(
                text: '🧭 Навигация',
              ),
            ),
            SizedBox(height: 6.h),
            GestureDetector(
              onTap: () => context.read<OrderCubit>().changeStatusOrder(
                    model.id,
                    status: 'paymend',
                  ),
              child: AppButtonV1(
                text: 'Завершить поездку',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
