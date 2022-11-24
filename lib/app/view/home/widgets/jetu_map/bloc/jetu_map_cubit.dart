import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jetu.driver/app/services/jetu_order/grapql_query.dart';
import 'package:jetu.driver/app/services/network_service.dart';
import 'package:jetu.driver/app/view/home/widgets/jetu_map/bloc/jetu_map_state.dart';
import 'package:jetu.driver/data/model/jetu_order_model.dart';
import 'package:latlong2/latlong.dart';

class JetuMapCubit extends Cubit<JetuMapState> {
  final GraphQLClient client;

  JetuMapCubit({
    required this.client,
  }) : super(JetuMapState.initial());

  final LatLng notEq = LatLng(0, 0);
  LatLngBounds _lastBounds = LatLngBounds();


  mapPanning(bool panning) {
    emit(state.copyWith(mapPanningStart: panning));
  }

  init() async {
    var coordinate = await Geolocator.getCurrentPosition();
    LatLng startPoint = LatLng(coordinate.latitude, coordinate.longitude);
    emit(state.copyWith(mapCenter: startPoint));

    String startAddress = await getGeocode(startPoint);
    emit(state.copyWith(currentAddress: startAddress));
  }

  Future<void> nearOrders(LatLngBounds? bounds, bool showOrders) async {
    if (showOrders) {
      if (bounds != null) {
        _lastBounds = bounds;
      }
      final variables = {
        "xmax": _lastBounds.southWest?.latitude,
        "xmin": _lastBounds.northEast?.longitude,
        "ymax": _lastBounds.southWest?.longitude,
        "ymin": _lastBounds.northEast?.longitude,
      };

      // final QueryOptions options = QueryOptions(
      //   document: gql(JetuOrdersQuery.fetchOrders()),
      //   fetchPolicy: FetchPolicy.networkOnly,
      //   variables: variables,
      //   parserFn: (json) =>
      //       JetuOrderList.fromUserJson(json, name: 'orders_by_bound'),
      // );
      // final QueryResult result = await client.query(options);
      // if (result.data != null) {
      //   JetuOrderList data = result.parsedData as JetuOrderList;
      //
      //   emit(state.copyWith(orderList: data.orders));
      // }
      emit(state.copyWith(variables: variables));
    }
  }

  onDetailView(JetuOrderModel model) async {
    List<LatLng> points = [model.aPoint(), model.bPoint()];
    List<LatLng> remoteDirections = await NetworkService.requestPathFromMapBox(
      [
        [model.aPointLat!, model.aPointLong!],
        [model.bPointLat!, model.bPointLong!],
      ],
    );

    emit(state.copyWith(points: points, route: remoteDirections));
  }

  Future<String> getGeocode(LatLng latLng) async {
    List<Placemark> place = await placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
      localeIdentifier: 'RU',
    );

    return place.first.street ?? '';
  }
}
