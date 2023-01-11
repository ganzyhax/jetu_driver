import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/services/jetu_order/grapql_query.dart';
import 'package:jetu.driver/app/view/home/widgets/jetu_map/bloc/jetu_map_cubit.dart';
import 'package:jetu.driver/app/view/home/widgets/jetu_map/bloc/jetu_map_state.dart';
import 'package:jetu.driver/app/view/order/bloc/order_cubit.dart';
import 'package:jetu.driver/app/view/order/order_detail_screen.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet/app_detail_sheet.dart';
import 'package:jetu.driver/app/widgets/graphql_wrapper/subscription_wrapper.dart';
import 'package:jetu.driver/app/widgets/list_item/order_item.dart';
import 'package:jetu.driver/data/model/jetu_order_model.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class JetuRequestPanel extends StatefulWidget {
  final PanelController panelController;

  const JetuRequestPanel({
    Key? key,
    required this.panelController,
  }) : super(key: key);

  @override
  State<JetuRequestPanel> createState() => _JetuRequestPanelState();
}

class _JetuRequestPanelState extends State<JetuRequestPanel> {
  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      panelController: widget.panelController,
      panelBuilder: (ScrollController sc) {
        return BlocBuilder<JetuMapCubit, JetuMapState>(
          builder: (context, state) {
            return SubscriptionWrapper<JetuOrderList>(
              queryString: JetuOrdersQuery.fetchOrders(),
              variables: state.variables ?? {},
              dataParser: (json) =>
                  JetuOrderList.fromUserJson(json, name: 'orders_by_bound'),
              contentBuilder: (JetuOrderList data) {
                if (data.orders.isNotEmpty) {
                  return ListView.builder(
                    controller: sc,
                    itemCount: data.orders.length,
                    itemBuilder: (context, index) {
                      final order = data.orders[index];
                      return OrderItem(
                        onTap: () async {
                          bool? isAccepted = await AppDetailSheet.open(
                            context,
                            widget: OrderDetailScreen(model: order),
                          );

                          if (isAccepted ?? false) {
                            context.read<OrderCubit>().acceptOrder(order.id);
                          }
                        },
                        model: order,
                      );
                    },
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 24.h),
                    Text(
                      'Заказы по этой точке не найден:',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Lottie.asset(
                      'assets/lottie/swipe.json',
                      width: 80.w,
                      height: 50.h,
                      fit: BoxFit.fill,
                    ),
                    Text(
                      'Ищите заказы, прикасаясь к карте',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
