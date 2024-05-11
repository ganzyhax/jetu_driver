import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql/client.dart';
import 'package:jetu.driver/app/const/app_shared_keys.dart';
import 'package:jetu.driver/app/services/functions/notification_func.dart';
import 'package:jetu.driver/app/services/jetu_drivers/grapql_mutation.dart';
import 'package:jetu.driver/data/model/jetu_order_model.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'yandex_map_event.dart';
part 'yandex_map_state.dart';

class YandexMapBloc extends Bloc<YandexMapEvent, YandexMapState> {
  Timer? _timer;
  GraphQLClient client;
  YandexMapBloc({required this.client}) : super(YandexMapInitial()) {
    List aPoint = ['', Point(latitude: 0, longitude: 0)];
    List bPoint = ['', Point(latitude: 0, longitude: 0)];
    bool isPointAChanged = false;
    String status = '';
    Map<String, dynamic> myLocation = {};
    String currentOrderClientId = '';
    bool mustChangeLocationTimer = true;
    bool mustChangeOnWayTimer = true;
    bool mustChangeStartedTimer = true;
    on<YandexMapEvent>((event, emit) async {
      if (event is YandexMapLoad) {
        if (mustChangeLocationTimer) {
          log('MUST MAP LOAD');

          status = '';
          mustChangeLocationTimer = true;
          mustChangeOnWayTimer = true;
          mustChangeStartedTimer = true;
          isPointAChanged = false;
          bPoint = ['', Point(latitude: 0, longitude: 0)];
          var coordinate = await Geolocator.getCurrentPosition();
          myLocation = {
            'lat': coordinate.latitude,
            'lon': coordinate.longitude
          };
          aPoint = [
            '',
            Point(
                latitude: coordinate.latitude, longitude: coordinate.longitude)
          ];
          emit(YandexMapLisSetPointA(
              aPoint: Point(
                  latitude: coordinate.latitude,
                  longitude: coordinate.longitude)));

          emit(YandexMapLoaded(
              myLocation: myLocation,
              aPoint: aPoint,
              bPoint: bPoint,
              isPointAChanged: isPointAChanged));

          add(YandexMapChangeLocation(changeType: 0));
        }
      }
      if (event is YandexMapSetAPoint) {
        aPoint = event.data;
        isPointAChanged = true;
        emit(YandexMapLisSetPointA(aPoint: aPoint[1]));
        emit(YandexMapLoaded(
            myLocation: myLocation,
            aPoint: aPoint,
            bPoint: bPoint,
            isPointAChanged: isPointAChanged));
      }
      if (event is YandexMapSetBPoint) {
        isPointAChanged = true;
        bPoint = event.data;
        emit(YandexMapLisSetPointB(bPoint: bPoint[1]));
        emit(YandexMapLoaded(
            myLocation: myLocation,
            aPoint: aPoint,
            bPoint: bPoint,
            isPointAChanged: isPointAChanged));
      }
      if (event is YandexMapSetBPointMinute) {
        if (bPoint[0].toString().contains(' min') ||
            bPoint[0].toString().contains('мин')) {
          bPoint[0] = bPoint[0].toString() + ', ' + event.minute;
        }

        // NotificationHelper().sendPushNotification(currentOrderClientId,
        //     'Jetu Pro', 'Водитель прибудет через ' + event.minute.toString());
        emit(YandexMapLoaded(
            myLocation: myLocation,
            aPoint: aPoint,
            bPoint: bPoint,
            isPointAChanged: isPointAChanged));
      }
      if (event is YandexMapNewOrderDrow) {
        log('MUST DROW NEW ORDER');
        _timer?.cancel();
        Point apoint = Point(
            latitude: event.data.aPoint().latitude,
            longitude: event.data.aPoint().longitude);

        Point bpoint = Point(
            latitude: event.data.bPoint().latitude,
            longitude: event.data.bPoint().longitude);
        bPoint[1] = Point(
            latitude: event.data.bPoint().latitude,
            longitude: event.data.bPoint().longitude);

        emit(YandexMapLisSetPointA(aPoint: apoint));
        emit(YandexMapLisSetPointB(bPoint: bpoint));
        emit(YandexMapLoaded(
            myLocation: myLocation,
            aPoint: aPoint,
            bPoint: bPoint,
            isPointAChanged: isPointAChanged));
      }
      if (event is YandexMapClearObject) {
        log('MUST CLEAR OBJECTS');
        try {
          _timer!.cancel();
        } catch (e) {}

        if (event.withLoad == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('inOrder', true);
          emit(YandexMapClearObjectList(withLoad: event.withLoad));
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('inOrder', true);
          emit(YandexMapClearObjectList(withLoad: event.withLoad));
        }
        emit(YandexMapLoaded(
            myLocation: myLocation,
            aPoint: aPoint,
            bPoint: bPoint,
            isPointAChanged: isPointAChanged));
      }

      if (event is YandexMapChangeLocation) {
        _timer?.cancel();
        _timer =
            Timer.periodic(const Duration(milliseconds: 4500), (timer) async {
          SharedPreferences _pref = await SharedPreferences.getInstance();
          String userId = await _pref.getString(AppSharedKeys.userId) ?? '';

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
          try {
            await client.mutate(options);
          } catch (e) {}

          if (event.changeType == 1) {
            add(YandexMapOnWayDraw(order: event.order!));
          } else if (event.changeType == 2) {
            add(YandexMapStartedDraw(order: event.order!));
          } else {
            add(YandexMapLoad());
          }
        });
      }
      if (event is YandexMapStartedDraw) {
        if (mustChangeStartedTimer) {
          log('MUST DOW TIMER');
          var coordinate = await Geolocator.getCurrentPosition();

          aPoint[1] = Point(
              latitude: event.order.bPoint().latitude,
              longitude: event.order.bPoint().longitude);

          emit(YandexMapLisSetPointA(aPoint: aPoint[1]));
          bPoint[1] = Point(
              latitude: coordinate.latitude, longitude: coordinate.longitude);
          emit(YandexMapLisSetPointB(bPoint: bPoint[1], isCar: true));
          emit(YandexMapLoaded(
              myLocation: myLocation,
              aPoint: aPoint,
              bPoint: bPoint,
              isPointAChanged: isPointAChanged));
          add(YandexMapChangeLocation(order: event.order, changeType: 2));
        }
      }
      if (event is YandexMapOnWayDraw) {
        if (mustChangeOnWayTimer) {
          log('MUST DROW ON WAY');
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('inOrder', true);
          currentOrderClientId = event.order.user!.token.toString();

          var coordinate = await Geolocator.getCurrentPosition();
          aPoint[1] = Point(
              latitude: event.order.aPoint().latitude,
              longitude: event.order.aPoint().longitude);

          emit(YandexMapLisSetPointA(aPoint: aPoint[1]));
          bPoint[1] = Point(
              latitude: coordinate.latitude, longitude: coordinate.longitude);
          emit(YandexMapLisSetPointB(bPoint: bPoint[1], isCar: true));
          emit(YandexMapLoaded(
              myLocation: myLocation,
              aPoint: aPoint,
              bPoint: bPoint,
              isPointAChanged: isPointAChanged));
          add(YandexMapChangeLocation(order: event.order, changeType: 1));
        }
      }

      if (event is YandexMapStopLoadTimer) {
        log('STOP LOAD TIMER');
        mustChangeLocationTimer = false;
        _timer!.cancel();
      }

      if (event is YandexMapStopOnWayTimer) {
        log('STOP ONWAY TIMER');
        mustChangeOnWayTimer = false;
        _timer!.cancel();
      }
      if (event is YandexMapStopStartTimer) {
        log('STOP START TIMER');
        mustChangeStartedTimer = false;
        _timer!.cancel();
      }
      if (event is YandexMapResetTimers) {
        log('RELOAD TIMERS TO TRUE');
        mustChangeStartedTimer = true;
        mustChangeOnWayTimer = true;
        mustChangeLocationTimer = true;
        isPointAChanged = true;
        _timer!.cancel();
      }
    });
  }
}

Future<List> getAddressFromCoordinates(
    double latitude, double longitude) async {
  const String apiKey = 'fb3fe377-05c0-4d2a-b49d-56694dd931b2';
  final String url =
      'https://geocode-maps.yandex.ru/1.x/?format=json&apikey=$apiKey&geocode=$longitude,$latitude';

  try {
    List res = [];
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final components =
          jsonResponse['response']['GeoObjectCollection']['featureMember'];

      if (components.isNotEmpty) {
        final address = components[0]['GeoObject']['name'];
        final point = components[0]['GeoObject']['Point'];

        res.add(address);
        res.add(point);
        return res;
      }
    } else {
      print('Failed to load address data');
    }
  } catch (e) {
    print('Error: $e');
  }
  return [];
}
