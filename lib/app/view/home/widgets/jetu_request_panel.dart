import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql/client.dart';
import 'package:jetu.driver/app/app_router/app_router.gr.dart';
import 'package:jetu.driver/app/const/app_shared_keys.dart';
import 'package:jetu.driver/app/extensions/context_extensions.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/services/jetu_drivers/grapql_mutation.dart';
import 'package:jetu.driver/app/services/jetu_drivers/grapql_subs.dart';

import 'package:jetu.driver/app/services/jetu_order/grapql_query.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu.driver/app/view/jetu_map/bloc/yandex_map_bloc.dart';
import 'package:jetu.driver/app/view/order/bloc/order_cubit.dart';
import 'package:jetu.driver/app/view/order/bloc/order_state.dart';
import 'package:jetu.driver/app/view/order/order_detail_screen.dart';
import 'package:jetu.driver/app/widgets/app_toast.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet/app_detail_sheet.dart';
import 'package:jetu.driver/app/widgets/graphql_wrapper/subscription_wrapper.dart';
import 'package:jetu.driver/app/widgets/list_item/order_item.dart';
import 'package:jetu.driver/data/model/jetu_order_model.dart';
import 'package:jetu.driver/gateway/graphql_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/bottom_sheet/app_bottom_sheet.dart';

class JetuRequestPanel extends StatefulWidget {
  final String driverId;
  const JetuRequestPanel({
    Key? key,
    required this.driverId,
  }) : super(key: key);

  @override
  State<JetuRequestPanel> createState() => _JetuRequestPanelState();
}

class _JetuRequestPanelState extends State<JetuRequestPanel> {
  final _player = AudioPlayer();
  bool isPlayed = false;
  List<String> orderIds = [];

  setAudio() async {}

  void playNewOrderAudio() async {
    try {
      var content = await rootBundle.load('assets/audio/new_order.mp3');
      final directory = await getApplicationDocumentsDirectory();
      var file = File("${directory.path}/new_order.v1.mp3");
      file.writeAsBytesSync(content.buffer.asUint8List());

      await _player.setFilePath(file.path);
      _player.setLoopMode(LoopMode.off);
      _player.setVolume(1.0);
      _player.play();
    } catch (err) {
      log('err: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      panelBuilder: (scroll) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20),
            width: context.sizeScreen.width,
            child: BlocBuilder<YandexMapBloc, YandexMapState>(
              builder: (context, state) {
                if (state is YandexMapLoaded) {
                  return BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, authState) {
                      return BlocBuilder<OrderCubit, OrderState>(
                        builder: (context, orderState) {
                          return SubscriptionWrapper<JetuOrderList>(
                            queryString: JetuOrdersQuery.fetchOrders(),
                            variables: state.myLocation,
                            dataParser: (json) => JetuOrderList.fromUserJson(
                              json,
                              name: 'order_by_location',
                            ),
                            contentBuilder: (JetuOrderList data) {
                              if (data.orders.isNotEmpty &&
                                  orderState.isOnline) {
                                if (!orderIds.contains(data.orders.first.id)) {
                                  orderIds.add(data.orders.first.id);
                                  if (orderIds.length == 1 ||
                                      orderIds.length == 4 ||
                                      orderIds.length == 7) {
                                    playNewOrderAudio();
                                  }
                                }
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 25,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(''),
                                          Text(''),
                                          Text(''),
                                          Text(''),
                                          Text(
                                            'Заказы',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text('Свободен',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              Switch(
                                                  activeColor: AppColors.blue,
                                                  value: orderState.isOnline,
                                                  onChanged: (e) async {
                                                    context
                                                        .read<OrderCubit>()
                                                        .setUserStatus(e);
                                                  })
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.black54,
                                    ),
                                    ListView.builder(
                                      itemCount: data.orders.length,
                                      controller: scroll,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        final order = data.orders[index];
                                        return OrderItem(
                                          onTap: () async {
                                            OrderDetailScreen(
                                              orderId: order.id,
                                              driverId: widget.driverId,
                                            );

                                            if (authState.isLogged) {
                                              BlocProvider.of<YandexMapBloc>(
                                                  context)
                                                ..add(YandexMapStopLoadTimer());
                                              bool? isAccepted =
                                                  await AppDetailSheet.open(
                                                context,
                                                widget: OrderDetailScreen(
                                                  orderId: order.id,
                                                  driverId: widget.driverId,
                                                ),
                                              );

                                              if (isAccepted ?? false) {
                                                context.read<OrderCubit>()
                                                  ..acceptOrder(
                                                    order.id,
                                                  );
                                              } else {
                                                BlocProvider.of<YandexMapBloc>(
                                                    context)
                                                  ..add(YandexMapResetTimers());
                                                BlocProvider.of<YandexMapBloc>(
                                                    context)
                                                  ..add(YandexMapClearObject(
                                                      withLoad: true));
                                              }
                                            } else {
                                              context.router.pushAndPopUntil(
                                                const LoginScreen(),
                                                predicate: (route) => true,
                                              );
                                            }
                                          },
                                          model: order,
                                        );
                                      },
                                    ),
                                  ],
                                );
                              }
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 25,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text('Свободен',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            Switch(
                                                activeColor: AppColors.blue,
                                                value: orderState.isOnline,
                                                onChanged: (e) async {
                                                  SharedPreferences _pref =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  String driverId =
                                                      _pref.getString(
                                                              AppSharedKeys
                                                                  .userId) ??
                                                          '';
                                                  if (driverId == '') {
                                                    AppToast.center(
                                                        'Вы не авторизованы');
                                                  } else {
                                                    final QueryOptions options =
                                                        QueryOptions(
                                                      document: gql(
                                                          JetuDriverSubscription
                                                              .getDriverAmountQuery()),
                                                      fetchPolicy: FetchPolicy
                                                          .networkOnly,
                                                      variables: {
                                                        "driverId": driverId,
                                                      },
                                                    );
                                                    final client =
                                                        await GraphQlService
                                                            .init();
                                                    QueryResult data =
                                                        await client.value
                                                            .query(options);
                                                    if (data.data![
                                                                'jetu_drivers_by_pk']
                                                            ['status'] ==
                                                        'banned') {
                                                      AppToast.center(
                                                          'Ваш аккаунт забанен!');
                                                    } else if (data.data![
                                                                'jetu_drivers_by_pk']
                                                            ['status'] ==
                                                        'pending_approval') {
                                                      AppToast.center(
                                                          'Ваш аккаунт на рассмотрении!');
                                                    } else {
                                                      if (data.data![
                                                                  'jetu_drivers_by_pk']
                                                              ['amount'] <
                                                          200) {
                                                        AppToast.center(
                                                            'У вас недостаточно средств');
                                                      } else {
                                                        context
                                                            .read<OrderCubit>()
                                                            .setUserStatus(e);
                                                      }
                                                    }
                                                  }
                                                })
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  (orderState.isOnline)
                                      ? Column(
                                          children: [
                                            Lottie.asset(
                                              'assets/lottie/car_anim.json',
                                              repeat: true,
                                              fit: BoxFit.cover,
                                              height:
                                                  context.sizeScreen.height *
                                                      0.4,
                                            ),
                                            Text(
                                              'В данный момент заказов нет!\n\nВы получите уведомление когда появится новый заказ',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppColors.black,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            Lottie.asset(
                                              'assets/lottie/online_anim.json',
                                              repeat: true,
                                              fit: BoxFit.cover,
                                              height:
                                                  context.sizeScreen.height *
                                                      0.27,
                                            ),
                                            Text(
                                              'В данный момент вы не свободны',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppColors.black,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        )
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        );
      },
    );
  }
}
