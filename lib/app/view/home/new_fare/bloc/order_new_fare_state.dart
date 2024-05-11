import 'package:jetu.driver/app/view/home/new_fare/bloc/order_new_fare_cubit.dart';
import 'package:jetu.driver/data/model/jetu_order_model.dart';

class OrderNewFareState {
  final bool isLoading;
  final OrderType orderType;
  final JetuOrderModel? orderModel;

  final int initFare;
  final int currentFare;
  final bool showFareButton;

  const OrderNewFareState({
    required this.isLoading,
    required this.orderType,
    this.orderModel,
    required this.initFare,
    required this.currentFare,
    required this.showFareButton,
  });

  factory OrderNewFareState.initial() => const OrderNewFareState(
        isLoading: false,
        orderType: OrderType.none,
        orderModel: null,
        initFare: 0,
        currentFare: 0,
        showFareButton: false,
      );

  OrderNewFareState copyWith({
    bool? isLoading,
    OrderType? orderType,
    JetuOrderModel? orderModel,
    int? initFare,
    int? currentFare,
    bool? showFareButton,
  }) =>
      OrderNewFareState(
        isLoading: isLoading ?? this.isLoading,
        orderType: orderType ?? this.orderType,
        orderModel: orderModel ?? this.orderModel,
        initFare: initFare ?? this.initFare,
        currentFare: currentFare ?? this.currentFare,
        showFareButton: showFareButton ?? this.showFareButton,
      );
}
