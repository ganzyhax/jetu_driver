part of 'transaction_cubit.dart';

class TransactionState {
  final bool isLoading;
  final List<JetuTransactionModel> transactionModel;

  TransactionState({
    required this.isLoading,
    required this.transactionModel,
  });

  factory TransactionState.initial() => TransactionState(
        isLoading: true,
        transactionModel: [],
      );

  TransactionState copyWith({
    bool? isLoading,
    List<JetuTransactionModel>? transactionModel,
  }) =>
      TransactionState(
        isLoading: isLoading ?? this.isLoading,
        transactionModel: transactionModel ?? this.transactionModel,
      );
}
