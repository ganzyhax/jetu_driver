import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/const/app_shared_keys.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/view/jetu_map/bloc/yandex_map_bloc.dart';
import 'package:jetu.driver/app/view/order/bloc/order_cubit.dart';
import 'package:jetu.driver/app/view/order/bloc/order_state.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet_widgets/bottom_sheet_title.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v1.dart';
import 'package:jetu.driver/data/model/jetu_order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderPaymendScreen extends StatelessWidget {
  final JetuOrderModel model;

  const OrderPaymendScreen({
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
            Text(
              'Оплатите наличными',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Поездка',
                        style: TextStyle(
                          color: AppColors.black.withOpacity(0.6),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '${model.cost ?? 'не указан'} тг',
                        style: TextStyle(
                          color: AppColors.black.withOpacity(0.6),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Налог',
                        style: TextStyle(
                          color: AppColors.black.withOpacity(0.6),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '+0.0 тг',
                        style: TextStyle(
                          color: AppColors.black.withOpacity(0.6),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Итог:',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${model.cost ?? 'не указан'} ₸',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            BlocBuilder<OrderCubit, OrderState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () async {
                    BlocProvider.of<YandexMapBloc>(context)
                      ..add(YandexMapResetTimers());
                    BlocProvider.of<YandexMapBloc>(context)
                      ..add(YandexMapClearObject(withLoad: false));
                    BlocProvider.of<YandexMapBloc>(context)
                      ..add(YandexMapLoad());
                    if (!state.isLoading) {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      String driverId =
                          pref.getString(AppSharedKeys.userId) ?? '';

                      context.read<OrderCubit>().changeStatusOrder(
                            model.id,
                            status: 'finished',
                            driverId: driverId,
                            payment: model.cost ?? '0',
                          );
                    }
                  },
                  child: AppButtonV1(
                    isLoading: state.isLoading,
                    text: 'Оплата наличными получена',
                  ),
                );
              },
            ),
            const Spacer(),
            const BottomSheetTitle(
              title: 'Ожидание оплаты клиента',
              isLargeTitle: true,
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
