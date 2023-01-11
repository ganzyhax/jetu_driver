import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:jetu.driver/app/services/jetu_drivers/grapql_subs.dart';
import 'package:jetu.driver/app/view/intercity/bloc/intercity_cubit.dart';

part 'app_city_state.dart';

class AppCityCubit extends Cubit<AppCityState> {
  final GraphQLClient client;

  AppCityCubit({
    required this.client,
  }) : super(AppCityState.initial());

  void search(String text) async {
    if (text.isEmpty) {
      emit(state.copyWith(cityList: []));
    }
    if (text.isNotEmpty) {
      final QueryOptions options = QueryOptions(
        document: gql(JetuDriverSubscription.getCity()),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {"query": "%$text%"},
        parserFn: (json) => PointList.fromUserJson(json),
      );

      QueryResult result = await client.query(options);
      PointList res = result.parsedData as PointList;

      emit(state.copyWith(cityList: res.points));
    }
  }
}
