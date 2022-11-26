import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:jetu.driver/app/di/injection.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/view/order_history/bloc/order_history_cubit.dart';
import 'package:jetu.driver/app/widgets/app_loader.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderHistoryCubit(
        client: injection(),
      )..init(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.white,
          title: const Text(
            'История заказов',
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
        ),
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const AppLoader();
                  }
                  if (state.orderList.isEmpty) {
                    return Center(
                      child: Text(
                        'Пока вы еще не сделали ни одной поездки',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: state.orderList.length,
                    itemBuilder: (context, index) {
                      final order = state.orderList[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ListTile(
                              horizontalTitleGap: 0,
                              contentPadding: const EdgeInsets.all(0),
                              leading: Column(
                                children: [
                                  Icon(
                                    Ionicons.location,
                                    color: AppColors.black.withOpacity(0.4),
                                    size: 12.sp,
                                  ),
                                  SizedBox(height: 2.h),
                                  const DottedLine(
                                    direction: Axis.vertical,
                                    //dashColor: CustomTheme.neutralColors,
                                    lineLength: 20,
                                    lineThickness: 1.0,
                                  ),
                                  SizedBox(height: 2.h),
                                  Icon(
                                    Ionicons.flag,
                                    color: AppColors.black.withOpacity(0.4),
                                    size: 12.sp,
                                  ),
                                ],
                              ),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.aPointAddress ?? '',
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    order.bPointAddress ?? '',
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Container(
                                width: 100.w,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: statusColor(order.status ?? ''),
                                ),
                                child: Text(
                                  '${order.cost} ₸\n${statusText(order.status ?? '')}',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              DateFormat('HH:mm , MMM d, yyyy', 'ru')
                                  .format(order.createdAt!),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color statusColor(String status) {
    switch (status) {
      case 'finished':
        return AppColors.green.withOpacity(0.2);
      case 'canceled':
        return AppColors.red.withOpacity(0.2);
      default:
        return AppColors.yellow.withOpacity(0.2);
    }
  }

  String statusText(String status) {
    switch (status) {
      case 'finished':
        return 'Выполнено';
      case 'canceled':
        return 'Отменен';
      default:
        return 'Не указан';
    }
  }
}
