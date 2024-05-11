import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jetu.driver/app/const/app_shared_keys.dart';
import 'package:jetu.driver/app/services/jetu_order/grapql_mutation.dart';
import 'package:jetu.driver/app/view/home/new_fare/bloc/order_new_fare_state.dart';
import 'package:jetu.driver/app/widgets/app_toast.dart';
import 'package:jetu.driver/data/model/jetu_order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum OrderType { none, requested, onWay, arrived, started, paymend }

class OrderNewFareCubit extends Cubit<OrderNewFareState> {
  final GraphQLClient client;

  OrderNewFareCubit({
    required this.client,
  }) : super(OrderNewFareState.initial());

  late SharedPreferences _prefs;

  Future<void> changeOrder(
    OrderType orderType,
    JetuOrderModel? orderModel,
  ) async =>
      emit(
        state.copyWith(
          orderType: orderType,
          orderModel: orderModel,
          initFare: int.parse(orderModel?.cost ?? '0'),
          currentFare: int.parse(orderModel?.cost ?? '0'),
        ),
      );

  Future<void> increaseFare() async => emit(
        state.copyWith(
          currentFare: state.currentFare + 50,
          showFareButton: true,
        ),
      );

  Future<void> decreaseFare() async {
    emit(state.copyWith(currentFare: state.currentFare - 50));

    log('${state.initFare} ${state.currentFare}, ${state.initFare > state.currentFare}');
    emit(state.copyWith(showFareButton: state.initFare < state.currentFare));
  }

  Future<void> setNewFare() async {
    emit(state.copyWith(
      currentFare: state.currentFare,
      initFare: state.currentFare,
    ));
    emit(state.copyWith(showFareButton: false));
    await createOrderFare();
    AppToast.center('Ваше предложение отправлено');
  }

  Future<void> createOrderFare() async {
    _prefs = await SharedPreferences.getInstance();
    String driverId = _prefs.getString(AppSharedKeys.userId) ?? '';

    final MutationOptions options = MutationOptions(
      document: gql(JetuOrderMutation.createFareAlert()),
      variables: {
        "object": {
          "order_id": state.orderModel?.id,
          "driver_id": driverId,
          "cost": state.currentFare.toString(),
        },
      },
    );

    final res = await client.mutate(options);
    log('message $res');
  }
}
