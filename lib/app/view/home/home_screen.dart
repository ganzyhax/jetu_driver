import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:jetu.driver/app/app_navigator.dart';
import 'package:jetu.driver/app/services/jetu_drivers/grapql_subs.dart';
import 'package:jetu.driver/app/services/jetu_order/grapql_subs.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu.driver/app/view/balance/balance_screen.dart';
import 'package:jetu.driver/app/view/home/bloc/home_cubit.dart';
import 'package:jetu.driver/app/view/home/widgets/jetu_map/bloc/jetu_map_cubit.dart';
import 'package:jetu.driver/app/view/home/widgets/jetu_map/bloc/jetu_map_state.dart';
import 'package:jetu.driver/app/view/home/widgets/jetu_map/jetu_map.dart';
import 'package:jetu.driver/app/view/home/widgets/jetu_request_panel.dart';
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
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.appConfig.version?.showForceUpdate ?? false) {
          if (state.storeUpdate) {
            AppNavigator.navigateToRemoteConfig(
              context,
              appConfig: state.appConfig,
            );
          }
        }
        if (state.appConfig.forceScreen?.show ?? false) {
          AppNavigator.navigateToRemoteConfig(
            context,
            appConfig: state.appConfig,
          );
        }
      },
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, authState) {
          // if (authState.status == 'pending_approval') {
          //   AppNavigator.navigateToStatus(context, status: authState.status);
          // }
        },
        builder: (context, authState) {
          if(!authState.isLogged){
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
              if (data.amount < 500) {
                return BalanceScreen(
                  userId: authState.userId,
                  showBackButton: false,
                );
              }
              return content(context, authState.userId);
            },
          );
        },
      ),
    );
  }

  Widget content(BuildContext context, String userId) {
    late MapController mapController = MapController();
    late PanelController panelController = PanelController();

    return BlocListener<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state.isSheetFullView) {
          if (panelController.isAttached) {
            panelController.open();
          }
        }
      },
      child: BlocListener<JetuMapCubit, JetuMapState>(
        listener: (context, state) async {
          if (state.mapPanningStart) {
            if (panelController.isAttached) {
              await panelController.close();
            }
          }
          // if (!state.mapPanningStart && state.orderList.isNotEmpty) {
          //   if (panelController.isAttached) {
          //     await panelController.open();
          //   }
          // }
        },
        child: Scaffold(
          appBar: const AppBarDefault(),
          drawer: const AppDrawer(),
          body: Stack(
            children: [
              JetuMap(mapController: mapController),
              SubscriptionWrapper<JetuOrderList>(
                queryString: JetuOrderSubscription.subscribeOrder(),
                variables: {
                  "driverId": userId,
                },
                dataParser: (json) => JetuOrderList.fromUserJson(json),
                contentBuilder: (JetuOrderList data) {
                  if (data.orders.isNotEmpty) {
                    context.read<OrderCubit>().fetchNewOrders(false);
                    switch (data.orders.first.status) {
                      case "onway":
                        context.read<HomeCubit>()..updateLocation();
                        return OrderOnWayScreen(
                          model: data.orders.first,
                          panelController: panelController,
                        );
                      case "arrived":
                        context.read<HomeCubit>()..updateLocation();
                        return OrderArrivedScreen(
                          model: data.orders.first,
                          panelController: panelController,
                        );
                      case "started":
                        context.read<HomeCubit>()..updateLocation();
                        return OrderStartedScreen(
                          model: data.orders.first,
                          panelController: panelController,
                        );
                      case "paymend":
                        context.read<HomeCubit>()..updateLocation();
                        return OrderPaymendScreen(
                          model: data.orders.first,
                          panelController: panelController,
                        );
                    }
                  }
                  return JetuRequestPanel(
                    panelController: panelController,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
