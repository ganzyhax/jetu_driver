class OrderState {
  final bool isLoading;
  final bool isSheetFullView;
  final bool showOrders;

  const OrderState({
    required this.isLoading,
    required this.isSheetFullView,
    required this.showOrders,
  });

  factory OrderState.initial() => OrderState(
        isLoading: false,
        isSheetFullView: false,
        showOrders: true,
      );

  OrderState copyWith({
    bool? isLoading,
    bool? isSheetFullView,
    bool? showOrders,
  }) =>
      OrderState(
        isLoading: isLoading ?? this.isLoading,
        isSheetFullView: isSheetFullView ?? this.isSheetFullView,
        showOrders: showOrders ?? this.showOrders,
      );
}
