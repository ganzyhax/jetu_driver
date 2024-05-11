import 'package:app_version_update/app_version_update.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jetu.driver/app/const/app_const.dart';
import 'package:jetu.driver/app/const/app_shared_keys.dart';
import 'package:jetu.driver/app/services/jetu_drivers/grapql_mutation.dart';
import 'package:jetu.driver/data/app/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GraphQLClient client;

  HomeCubit({
    required this.client,
  }) : super(HomeState.initial());

  late SharedPreferences _pref;

  Future<void> init() async {
    emit(state.copyWith(
      isLoading: true,
      storeUpdate: true,
    ));

    final res = await AppVersionUpdate.checkForUpdates(
        appleId: AppConst.appStoreId,
        playStoreId: AppConst.playMarketId,
        country: 'kz');

    emit(
      state.copyWith(
        isLoading: false,
        appConfig: AppConfig(),
        storeUpdate: res.canUpdate,
      ),
    );
  }

  Future<void> updateLocation() async {
    _pref = await SharedPreferences.getInstance();
    String userId = _pref.getString(AppSharedKeys.userId) ?? '';
    var coordinate = await Geolocator.getCurrentPosition();

    final MutationOptions options = MutationOptions(
      document: gql(JetuDriverMutation.updateLocation()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "userId": userId,
        "lat": coordinate.latitude,
        "long": coordinate.longitude,
      },
    );

    QueryResult res = await client.mutate(options);
    // print(res);
    emit(state.copyWith(isLoading: false));
  }
}
