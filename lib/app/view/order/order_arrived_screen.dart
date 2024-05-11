import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/view/order/bloc/order_cubit.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet/app_detail_sheet.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet_widgets/bottom_sheet_title.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet_widgets/order_options.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v1.dart';
import 'package:jetu.driver/app/widgets/button/light_colored_button.dart';
import 'package:jetu.driver/app/widgets/list_item/order_item.dart';
import 'package:jetu.driver/data/model/jetu_order_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class OrderArrivedScreen extends StatelessWidget {
  final JetuOrderModel model;

  const OrderArrivedScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
        ),
        child: Column(
          children: [

            SizedBox(height: 24.h),
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
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: () => context.read<OrderCubit>().changeStatusOrder(
                model.id,
                status: 'started',
              ),
              child: const AppButtonV1(
                text: 'Начать поездку',
              ),
            ),
            const Spacer(),
            const BottomSheetTitle(
              title: 'Пользователь уведомлен',
            ),
            SizedBox(height: 12.h),

          ],
        ),
      ),
    );
  }
}
