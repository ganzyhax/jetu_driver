import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jetu.driver/app/app_router/app_router.gr.dart';
import 'package:jetu.driver/app/services/functions/notification_func.dart';
import 'package:jetu.driver/app/services/jetu_drivers/grapql_subs.dart';
import 'package:jetu.driver/app/services/jetu_order/grapql_subs.dart';
import 'package:jetu.driver/app/services/on_close_service.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu.driver/app/view/home/bloc/home_cubit.dart';
import 'package:jetu.driver/app/view/home/widgets/jetu_request_panel.dart';
import 'package:jetu.driver/app/view/jetu_map/bloc/yandex_map_bloc.dart';

import 'package:jetu.driver/app/view/jetu_map/jetu_map_yandex.dart';

import 'package:jetu.driver/app/view/order/bloc/order_cubit.dart';
import 'package:jetu.driver/app/view/order/bloc/order_state.dart';
import 'package:jetu.driver/app/view/order/order_arrived_screen.dart';

import 'package:jetu.driver/app/view/order/order_onway_screen.dart';
import 'package:jetu.driver/app/view/order/order_paymend_screen.dart';
import 'package:jetu.driver/app/view/order/order_started_screen.dart';
import 'package:jetu.driver/app/widgets/app_bar/app_bar_default.dart';
import 'package:jetu.driver/app/widgets/drawer/app_drawer.dart';
import 'package:jetu.driver/app/widgets/graphql_wrapper/subscription_wrapper.dart';
import 'package:jetu.driver/data/model/jetu_driver_model.dart';
import 'package:jetu.driver/data/model/jetu_order_model.dart';
import 'package:jetu.driver/data/model/jetu_user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppLifecycleObserver _appLifecycleObserver = AppLifecycleObserver();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_appLifecycleObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_appLifecycleObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.appConfig.version?.showForceUpdate ?? false) {
          if (state.storeUpdate) {
            context.router.pushAndPopUntil(
              RemoteConfigScreen(
                appConfig: state.appConfig,
              ),
              predicate: (Route<dynamic> route) => false,
            );
          }
        }
        if (state.appConfig.forceScreen?.show ?? false) {
          context.router.pushAndPopUntil(
            RemoteConfigScreen(
              appConfig: state.appConfig,
            ),
            predicate: (Route<dynamic> route) => false,
          );
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          if (!authState.isLogged) {
            return content(context, authState.userId);
          }
          return SubscriptionWrapper<JetuDriverModel>(
            queryString: JetuDriverSubscription.getDriverAmount(),
            variables: {
              "driverId": authState.userId,
            },
            dataParser: (json) => JetuDriverModel.fromJson(
              json,
              name: 'jetu_drivers_by_pk',
            ),
            contentBuilder: (JetuDriverModel data) {
              // 437b2ca3-4bd0-4918-aef7-2b02f60dc94c

              // if (data.amount < 500) {
              //   return bS.BalanceScreen(
              //     userId: authState.userId,
              //     showBackButton: false,
              //   );
              // }

              return content(context, authState.userId);
            },
          );
        },
      ),
    );
  }

  Widget content(BuildContext context, String driverId) {
    return BlocListener<OrderCubit, OrderState>(
        listener: (context, state) {},
        child: Scaffold(
          appBar: const AppBarDefault(),
          drawer: const AppDrawer(),
          body: Stack(
            children: [
              JetuYandexMap(
                isDriver: true,
              ),
              SubscriptionWrapper<JetuOrderList>(
                queryString: JetuOrderSubscription.subscribeOrder(),
                variables: {
                  "driverId": driverId,
                },
                dataParser: (json) => JetuOrderList.fromUserJson(json),
                contentBuilder: (JetuOrderList data) {
                  if (data.orders.isNotEmpty) {
                    context.read<OrderCubit>().fetchNewOrders(false);
                    switch (data.orders.first.status) {
                      case "onway":
                        BlocProvider.of<YandexMapBloc>(context)
                          ..add(YandexMapStopLoadTimer());
                        BlocProvider.of<YandexMapBloc>(context)
                          ..add(YandexMapClearObject(withLoad: false));
                        BlocProvider.of<YandexMapBloc>(context)
                          ..add(YandexMapChangeLocation(
                              order: data.orders.first, changeType: 1));
                        return OrderOnWayScreen(
                          model: data.orders.first,
                        );
                      case "arrived":
                        BlocProvider.of<YandexMapBloc>(context)
                          ..add(YandexMapStopOnWayTimer());
                        BlocProvider.of<YandexMapBloc>(context)
                          ..add(YandexMapClearObject(withLoad: false));
                        return OrderArrivedScreen(
                          model: data.orders.first,
                        );
                      case "started":
                        BlocProvider.of<YandexMapBloc>(context)
                          ..add(YandexMapStopOnWayTimer());
                        BlocProvider.of<YandexMapBloc>(context)
                          ..add(YandexMapClearObject(withLoad: false));
                        BlocProvider.of<YandexMapBloc>(context)
                          ..add(YandexMapChangeLocation(
                              order: data.orders.first, changeType: 2));

                        return OrderStartedScreen(
                          model: data.orders.first,
                        );
                      case "paymend":
                        BlocProvider.of<YandexMapBloc>(context)
                          ..add(YandexMapStopStartTimer());
                        BlocProvider.of<YandexMapBloc>(context)
                          ..add(YandexMapClearObject(withLoad: true));

                        return OrderPaymendScreen(
                          model: data.orders.first,
                        );
                    }
                  }

                  return JetuRequestPanel(driverId: driverId);
                },
              )
            ],
          ),
        ));
  }
}
