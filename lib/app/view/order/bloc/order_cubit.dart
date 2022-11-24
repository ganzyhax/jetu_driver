import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jetu.driver/app/const/app_shared_keys.dart';
import 'package:jetu.driver/app/services/jetu_order/grapql_mutation.dart';
import 'package:jetu.driver/app/view/order/bloc/order_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderCubit extends Cubit<OrderState> {
  final GraphQLClient client;

  OrderCubit({
    required this.client,
  }) : super(OrderState.initial());

  late SharedPreferences _prefs;

  acceptOrder(String orderId) async {
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

  changeStatusOrder(String orderId, {required String status}) async {
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
      print('showOrders when finished/canceled');
      showOrders = true;
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
