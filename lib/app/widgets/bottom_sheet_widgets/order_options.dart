import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jetu.driver/app/view/order/bloc/order_cubit.dart';
import 'package:jetu.driver/app/widgets/app_setting_tile_item.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet_widgets/bottom_sheet_title.dart';
import 'package:jetu.driver/data/model/jetu_order_model.dart';

class OrderOptions extends StatelessWidget {
  final JetuOrderModel model;

  const OrderOptions({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetTitle(title: 'Опция'),
          AppSettingTileItem(
            onTap: () => context.read<OrderCubit>()
              ..changeStatusOrder(
                model.id,
                status: 'canceled',
              ),
            icon: Ionicons.remove_circle_outline,
            title: 'Отменить заказ',
          ),
          Divider(),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}
