class OrderState {
  final bool isLoading;
  final bool isSheetFullView;
  final bool showOrders;
  final bool isOnline;

  const OrderState({
    required this.isLoading,
    required this.isSheetFullView,
    required this.showOrders,
    required this.isOnline,
  });

  factory OrderState.initial() => OrderState(
        isLoading: false,
        isSheetFullView: false,
        showOrders: true,
        isOnline: false,
      );

  OrderState copyWith({
    bool? isLoading,
    bool? isSheetFullView,
    bool? showOrders,
    bool? isOnline,
  }) =>
      OrderState(
        isOnline: isOnline ?? this.isOnline,
        isLoading: isLoading ?? this.isLoading,
        isSheetFullView: isSheetFullView ?? this.isSheetFullView,
        showOrders: showOrders ?? this.showOrders,
      );
}
