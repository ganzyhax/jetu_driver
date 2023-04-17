import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:jetu.driver/app/const/app_shared_keys.dart';
import 'package:jetu.driver/app/services/jetu_drivers/grapql_subs.dart';
import 'package:jetu.driver/data/model/jetu_transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final GraphQLClient client;

  TransactionCubit({
    required this.client,
  }) : super(TransactionState.initial());

  void init() async {
    emit(state.copyWith(isLoading: true));
    SharedPreferences pref = await SharedPreferences.getInstance();

    final QueryOptions options = QueryOptions(
      document: gql(JetuDriverSubscription.getDriverTransactionHistory()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "driverId": pref.getString(AppSharedKeys.userId),
      },
      parserFn: (json) => JetuTransactionList.fromUserJson(json),
    );

    QueryResult result = await client.query(options);
    JetuTransactionList res = result.parsedData as JetuTransactionList;
    emit(state.copyWith(
      isLoading: false,
      transactionModel: res.orders,
    ));
  }
}
