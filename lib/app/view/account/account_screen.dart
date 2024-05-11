import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jetu.driver/app/app_router/app_router.gr.dart';
import 'package:jetu.driver/app/di/injection.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/services/jetu_auth/grapql_query.dart';
import 'package:jetu.driver/app/view/account/widgets/statistics_bar.dart';
import 'package:jetu.driver/app/view/account/widgets/today_work_info_card.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu.driver/app/view/order_history/bloc/order_history_cubit.dart';
import 'package:jetu.driver/app/widgets/app_setting_tile_item.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet_widgets/bottom_sheet_title.dart';
import 'package:jetu.driver/app/widgets/graphql_wrapper/query_wrapper.dart';
import 'package:jetu.driver/app/widgets/image_with_uploader.dart';
import 'package:jetu.driver/app/widgets/verified.dart';
import 'package:jetu.driver/data/model/jetu_driver_model.dart';
import 'package:jetu.driver/data/model/jetu_order_model.dart';

class AccountScreen extends StatelessWidget {
  final String userId;

  const AccountScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 240,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 44, 114, 172),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                              top: 10,
                              left: 10,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 95,
                                  ),
                                  Text(
                                    'Мой профиль',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    width: 75,
                                  ),
                                  IconButton(
                                    focusColor: Colors.white,
                                    onPressed: () async {
                                      await showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: false,
                                        builder: (ct) {
                                          return SafeArea(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const BottomSheetTitle(
                                                    title: 'Меню'),
                                                AppSettingTileItem(
                                                  onTap: () {
                                                    showDialog(
                                                      context: ct,
                                                      builder: (BuildContext
                                                          ncontext) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              "Удаление аккаунта"),
                                                          content: const Text(
                                                              "Вы уверены, что хотите удалить свой аккаунт? Вы можете снова войти в систему в течение 30 дней, чтобы восстановить учетную запись. По истечении этого периода ваши данные будут полностью удалены."),
                                                          actions: [
                                                            Row(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              8),
                                                                  child:
                                                                      TextButton(
                                                                    onPressed: () => context
                                                                        .read<
                                                                            AuthCubit>()
                                                                        .logout(
                                                                            context),
                                                                    child:
                                                                        const Text(
                                                                      "Удалить аккаунт",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .end,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color(
                                                                            0xffb20d0e),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                  child:
                                                                      const Text(
                                                                    "Отмена",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
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
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 18,
                  top: 145, // AppSettingTileItem(
                  //   firstClosePage: false,
                  // onTap: () => context.router.push(BalanceScreen(
                  //   userId: userId,
                  //   showBackButton: true,
                  // )),
                  //   icon: Ionicons.cash_outline,
                  //   title: 'Мой баланс',
                  // ),
                  // AppSettingTileItem(
                  //   firstClosePage: false,
                  // onTap: () => context.router.push(
                  //   const OrderHistoryScreen(),
                  // ),
                  //   icon: Ionicons.car_outline,
                  //   title: 'История заказов',
                  // ),

                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => context.router.push(BalanceScreen(
                          userId: userId,
                          showBackButton: true,
                        )),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Icon(Icons.monetization_on_outlined),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Мой баланс')
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      InkWell(
                        onTap: () => context.router.push(
                          const OrderHistoryScreen(),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Icon(Icons.history),
                              SizedBox(
                                width: 5,
                              ),
                              Text('История заказов')
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 60,
                  child: QueryWrapper<JetuDriverModel>(
                    queryString: JetuAuthQuery.fetchUserInfo(),
                    variables: {"userId": userId},
                    dataParser: (json) => JetuDriverModel.fromJson(
                      json,
                      name: 'jetu_drivers_by_pk',
                    ),
                    contentBuilder: (JetuDriverModel data) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 25,
                              ),
                              ImageCardWithUploader(
                                selectedFile: (file) {
                                  uploadImage(file!,
                                      driverId: data.id.toString());
                                },
                                userImage: data.avatarUrl.toString(),
                              ),
                              SizedBox(width: 8.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${data.name ?? 'Пусто'} ${data.surname ?? ''}',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Ваш баланс: ' +
                                            data.amount.toString() +
                                            ' тг' ??
                                        'Не указан',
                                    style: TextStyle(
                                      color: AppColors.white.withOpacity(0.8),
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Positioned(
                //     top: 100,
                //     child: Container(
                //       height: 40,
                //       child: Column(
                //         children: [
                //           Row(
                //             children: [
                //               AppSettingTileItem(
                //                 firstClosePage: false,
                //                 onTap: () => context.router.push(BalanceScreen(
                //                   userId: userId,
                //                   showBackButton: true,
                //                 )),
                //                 icon: Ionicons.cash_outline,
                //                 title: 'Мой баланс',
                //               ),
                //               AppSettingTileItem(
                //                 firstClosePage: false,
                //                 onTap: () => context.router.push(
                //                   const OrderHistoryScreen(),
                //                 ),
                //                 icon: Ionicons.car_outline,
                //                 title: 'История заказов',
                //               ),
                //             ],
                //           )
                //         ],
                //       ),
                //     )),

                Positioned(
                    top: 195,
                    left: 14,
                    child: BlocProvider(
                      create: (context) => OrderHistoryCubit(
                        client: injection(),
                      )..init(),
                      child: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
                        builder: (context, state) {
                          DateTime now = DateTime.now();
                          int orderCount = 0;
                          int orderCost = 0;

                          for (var order in state.orderList) {
                            DateTime givenDate =
                                DateTime.parse(order.createdAt.toString());
                            bool result = now.year == givenDate.year &&
                                now.month == givenDate.month &&
                                now.day == givenDate.day;
                            if (result) {
                              orderCount++;
                              orderCost =
                                  orderCost + int.parse(order.cost.toString());
                            }
                          }

                          return Column(
                            children: [
                              Center(
                                child: TodayWorkInfoCard(
                                  rides: orderCount.toString(),
                                  cost: orderCost.toString(),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )),

                Positioned(
                  top: 380,
                  left: 10,
                  child: BlocProvider(
                    create: (context) => OrderHistoryCubit(
                      client: injection(),
                    )..init(),
                    child: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
                      builder: (context, state) {
                        List weekList = [];
                        int allWeekCost = 0;
                        Map<String, double> weeklyEarningsByDay =
                            calculateWeeklyEarningsByDay(state.orderList);
                        weeklyEarningsByDay.forEach((day, earnings) {
                          weekList.add(earnings);
                          allWeekCost = allWeekCost + earnings.toInt();
                        });
                        return Column(
                          children: [
                            Center(
                                child: StatisticsBar(
                              allWeekCost: allWeekCost.toString(),
                              weekResult: weekList,
                            )),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, double> calculateWeeklyEarningsByDay(
      List<JetuOrderModel> orderList) {
    Map<String, double> earningsByDay = {
      "Понедельник": 0,
      "Вторник": 0,
      "Среда": 0,
      "Четверг": 0,
      "Пятница": 0,
      "Суббота": 0,
      "Воскресенье": 0,
    };

    List<String> dayNames = [
      "Понедельник",
      "Вторник",
      "Среда",
      "Четверг",
      "Пятница",
      "Суббота",
      "Воскресенье",
    ];

    for (var order in orderList) {
      DateTime createdAt = DateTime.parse(order.createdAt.toString());
      String dayName = dayNames[createdAt.weekday - 1];
      earningsByDay[dayName] =
          (earningsByDay[dayName] ?? 0) + double.parse(order.cost.toString());
    }

    return earningsByDay;
  }
}
