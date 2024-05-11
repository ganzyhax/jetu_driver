import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jetu.driver/app/const/app_shared_keys.dart';
import 'package:jetu.driver/app/services/jetu_drivers/grapql_mutation.dart';
import 'package:jetu.driver/app/services/jetu_drivers/grapql_subs.dart';
import 'package:jetu.driver/app/services/jetu_order/grapql_mutation.dart';
import 'package:jetu.driver/app/view/jetu_map/bloc/yandex_map_bloc.dart';
import 'package:jetu.driver/app/view/order/bloc/order_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderCubit extends Cubit<OrderState> {
  final GraphQLClient client;

  OrderCubit({
    required this.client,
  }) : super(OrderState.initial());

  late SharedPreferences _prefs;

  void acceptOrder(String orderId) async {
    emit(state.copyWith(isLoading: true));

    _prefs = await SharedPreferences.getInstance();
    String driverId = _prefs.getString(AppSharedKeys.userId) ?? '';

    final MutationOptions options = MutationOptions(
      document: gql(JetuOrderMutation.acceptOrder()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "orderId": orderId,
        "driverId": driverId,
      },
    );

    await client.mutate(options);
    emit(state.copyWith(
      isLoading: false,
      isSheetFullView: true,
      showOrders: false,
    ));
  }

  void setUserStatus(bool value) async {
    _prefs = await SharedPreferences.getInstance();
    String driverId = await _prefs.getString(AppSharedKeys.userId) ?? '';
    print('Driver id here' + driverId);
    final MutationOptions options = MutationOptions(
      document: gql(JetuDriverMutation.updateUserFreeStatus()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {"userId": driverId, "value": value},
    );
    var data = await client.mutate(options);
    print(data);
    emit(state.copyWith(isOnline: value));
  }

  void changeStatusOrder(
    String orderId, {
    required String status,
    String? driverId,
    String? payment,
  }) async {
    bool showOrders = false;
    emit(state.copyWith(isLoading: true));

    final MutationOptions options = MutationOptions(
      document: gql(JetuOrderMutation.updateStatusOrder()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "orderId": orderId,
        "status": status,
      },
    );

    await client.mutate(options);
    if (status == 'finished' || status == 'canceled') {
      showOrders = true;
    }

    if (payment != '0' && payment != null && status == 'finished') {
      showOrders = true;
      final QueryOptions options = QueryOptions(
        document: gql(JetuDriverSubscription.getDriverAmountQuery()),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          "driverId": driverId,
        },
      );
      QueryResult data = await client.query(options);
      double orderCash = double.parse(payment.toString());
      double commission = orderCash * 0.06;
      double userBalance =
          double.parse(data.data!['jetu_drivers_by_pk']['amount'].toString());
      double updateBalance = userBalance - commission;

      final MutationOptions options2 = MutationOptions(
        document: gql(JetuDriverMutation.addDriverBalance()),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {"driverId": driverId, "amount": updateBalance},
      );

      await client.mutate(options2);
    }
    emit(state.copyWith(
      isLoading: false,
      isSheetFullView: true,
      showOrders: showOrders,
    ));
  }

  fetchNewOrders(bool fetch) {
    emit(state.copyWith(showOrders: fetch));
  }
}
