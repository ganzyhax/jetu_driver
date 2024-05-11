import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/di/injection.dart';
import 'package:jetu.driver/app/extensions/context_extensions.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/services/functions/notification_func.dart';
import 'package:jetu.driver/app/services/jetu_order/grapql_subs.dart';
import 'package:jetu.driver/app/view/home/new_fare/bloc/order_new_fare_cubit.dart';
import 'package:jetu.driver/app/view/home/new_fare/bloc/order_new_fare_state.dart';
import 'package:jetu.driver/app/view/jetu_map/bloc/yandex_map_bloc.dart';
import 'package:jetu.driver/app/view/jetu_map/jetu_map_yandex.dart';
import 'package:jetu.driver/app/widgets/app_toast.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v1.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v2.dart';
import 'package:jetu.driver/app/widgets/graphql_wrapper/subscription_wrapper.dart';
import 'package:jetu.driver/app/widgets/list_item/order_item.dart';
import 'package:jetu.driver/data/model/jetu_order_model.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../const/app_const.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  final String driverId;

  const OrderDetailScreen({
    Key? key,
    required this.orderId,
    required this.driverId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SubscriptionWrapper<JetuOrderList>(
      queryString: JetuOrderSubscription.subscribeOrderDetail(),
      variables: {
        "orderId": orderId,
      },
      dataParser: (json) => JetuOrderList.fromUserJson(json),
      contentBuilder: (JetuOrderList data) {
        if (data.orders.isEmpty) {
          return Text('ddd');
        }
        JetuOrderModel orderModel = data.orders.first;
        if (orderModel.driver != null && orderModel.driver?.id != driverId) {
          Navigator.of(context).pop(false);
          AppToast.center('Заказ уже принят');
        }

        if (orderModel.driver != null && orderModel.driver?.id == driverId) {
          // Navigator.of(context).pop(true);
          AppToast.center('Вы приняли заказ');
        }

        return SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              BlocProvider.value(
                value: BlocProvider.of<YandexMapBloc>(context)
                  ..add(YandexMapNewOrderDrow(data: orderModel)),
                child: JetuYandexMap(
                  isDriver: false,
                ),
              ),
              BlocProvider(
                create: (context) => OrderNewFareCubit(
                  client: injection(),
                )..changeOrder(
                    OrderType.none,
                    orderModel,
                  ),
                child: BlocBuilder<OrderNewFareCubit, OrderNewFareState>(
                  builder: (context, state) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 5.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.bottomCenter,
                      height: context.sizeScreen.height * 0.48,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OrderItem(model: data.orders.first),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (state.showFareButton) {
                                      context
                                          .read<OrderNewFareCubit>()
                                          .decreaseFare();
                                    }
                                  },
                                  child: AppButtonV1(
                                    height: 30.h,
                                    isActive: state.showFareButton,
                                    inActiveColor:
                                        AppColors.blue.withOpacity(0.07),
                                    inActiveTextColor:
                                        AppColors.white.withOpacity(0.6),
                                    text: '-50',
                                  ),
                                ),
                              ),
                              SizedBox(width: 24.w),
                              Text(
                                '${state.currentFare} ₸',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 24.w),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    context
                                        .read<OrderNewFareCubit>()
                                        .increaseFare();
                                  },
                                  child: AppButtonV1(
                                    height: 30.h,
                                    isActive: true,
                                    inActiveColor:
                                        AppColors.blue.withOpacity(0.07),
                                    inActiveTextColor:
                                        AppColors.white.withOpacity(0.6),
                                    text: '+50',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          GestureDetector(
                            onTap: () {
                              if (state.showFareButton) {
                                context.read<OrderNewFareCubit>().setNewFare();

                                log(orderModel.user!.name.toString());
                                log(orderModel.user!.token.toString());
                                log(orderModel.user!.phone.toString());
                                log(orderModel.user!.id.toString());
                                NotificationHelper().sendPushNotification(
                                    orderModel.user!.token.toString(),
                                    'Jetu',
                                    'Водитель вам предлагает цену: ' +
                                        state.currentFare.toString() +
                                        'тг');

                                Navigator.of(context).pop(false);
                              } else {
                                NotificationHelper().sendPushNotification(
                                    orderModel.user!.token.toString(),
                                    'Jetu',
                                    'Водитель принял ваш заказ!');
                                Navigator.of(context).pop(true);
                              }
                            },
                            child: AppButtonV1(
                              text: state.showFareButton
                                  ? 'Предложить цену'
                                  : 'Принять заказ',
                            ),
                          ),
                          SizedBox(height: 6.h),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(false),
                            child: const AppButtonV2(
                              text: 'Пропустить',
                            ),
                          ),
                          SizedBox(height: 7.h),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
