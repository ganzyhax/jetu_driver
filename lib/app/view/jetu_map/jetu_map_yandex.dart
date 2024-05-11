import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jetu.driver/app/services/functions/notification_func.dart';
import 'package:jetu.driver/app/view/jetu_map/bloc/yandex_map_bloc.dart';

import 'package:yandex_mapkit/yandex_mapkit.dart';

class JetuYandexMap extends StatefulWidget {
  final bool isDriver;
  const JetuYandexMap({
    required this.isDriver,
    Key? key,
  }) : super(key: key);

  @override
  State<JetuYandexMap> createState() => _JetuYandexMapState();
}

class _JetuYandexMapState extends State<JetuYandexMap> {
  @override
  void initState() {
    super.initState();
    if (widget.isDriver) {
      // getCurrentLocation().ignore();
    }
  }

  List<MapObject<dynamic>> mapObjects = [];
  final yandexMapController = Completer<YandexMapController>();
  List<Point> points = [];
  DrivingResultWithSession? _drivingResultWithSession;
  List<PolylineMapObject> _drivingMapLines = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<YandexMapBloc, YandexMapState>(
      listener: (context, state) {
        if (state is YandexMapClearObjectList) {
          if (state.withLoad) {
            mapObjects.clear();
            _drivingResultWithSession = null;
            _drivingMapLines.clear();
            points.clear();
            setState(() {});
            BlocProvider.of<YandexMapBloc>(context)..add(YandexMapLoad());
          } else {
            mapObjects.clear();
            _drivingResultWithSession = null;
            _drivingMapLines.clear();
            points.clear();
            setState(() {});
          }
        }

        if (state is YandexMapLisSetPointA) {
          _drivingResultWithSession = null;
          if (points.length == 0) {
            print('FIRST ADD A');
            points.add(state.aPoint);

            addMapObject(state.aPoint, true);
            _moveToCurrentLocation(state.aPoint, true);
            setState(() {});
          } else {
            print('Second ADD A');

            points[0] = state.aPoint;
            if (state.isOnlyDriver == true) {
              if (points.length > 2) {
                mapObjects.clear();
                _drivingResultWithSession = null;
                _drivingMapLines.clear();
                points.clear();
                setState(() {});
              }
            }
            addMapObject(state.aPoint, true);

            _moveToCurrentLocation(state.aPoint, true);
            setState(() {});

            if (points.length == 2) {
              _drivingResultWithSession = _getDrivingResultWithSession(
                startPoint: points.first,
                endPoint: points.last,
              );
              setState(() {});

              _buildRoutes();
            }
          }
        }
        if (state is YandexMapLisSetPointB) {
          _drivingResultWithSession = null;
          if (points.length == 1) {
            print('FIRST ADD B');
            points.add(state.bPoint);
            if (state.isCar == true) {
              addMapObject(state.bPoint, false, isCar: true);
            } else {
              addMapObject(state.bPoint, false);
            }

            double middleLatitude =
                (points[0].latitude + state.bPoint.latitude) / 2;
            double middleLongitude =
                (points[0].longitude + state.bPoint.longitude) / 2;
            final middlePointCamera =
                Point(latitude: middleLatitude, longitude: middleLongitude);
            _moveToCurrentLocation(middlePointCamera, true, fullShow: true);
            setState(() {});
          } else {
            print('SECOND ADD B');
            points[1] = state.bPoint;

            double middleLatitude =
                (points[0].latitude + state.bPoint.latitude) / 2;
            double middleLongitude =
                (points[0].longitude + state.bPoint.longitude) / 2;
            final middlePointCamera =
                Point(latitude: middleLatitude, longitude: middleLongitude);

            if (state.isCar == true) {
              print('IS CAR');
              addMapObject(
                state.bPoint,
                false,
                isCar: true,
              );
              _moveToCurrentLocation(state.bPoint, true, fullShow: true);
            } else {
              addMapObject(
                state.bPoint,
                false,
              );
              _moveToCurrentLocation(middlePointCamera, true, fullShow: true);
            }

            setState(() {});
          }
          _drivingResultWithSession = _getDrivingResultWithSession(
            startPoint: points.first,
            endPoint: points.last,
          );
          setState(() {});
          _buildRoutes();
        }
      },
      child: BlocBuilder<YandexMapBloc, YandexMapState>(
        builder: (context, state) {
          if (state is YandexMapLoaded) {
            return Stack(
              children: [
                YandexMap(
                  mapObjects: mapObjects,
                  onMapCreated: (controller) {
                    try {
                      yandexMapController.complete(controller);
                    } catch (e) {
                      yandexMapController.complete(controller);
                      log(e.toString());
                    }
                  },
                ),
                (state.isPointAChanged)
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(
                          bottom: 32,
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: RawMaterialButton(
                            onPressed: () async {
                              await getCurrentLocation();
                            },
                            fillColor: Colors.white,
                            padding: const EdgeInsets.all(12),
                            shape: const CircleBorder(),
                            child: const Icon(
                              CupertinoIcons.location_fill,
                            ),
                          ),
                        ),
                      ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  Future<void> _buildRoutes() async {
    if (points.length == 2) {
      final drivingResult = await _drivingResultWithSession?.result;
      _drivingMapLines.clear();
      setState(() {
        for (var element in drivingResult?.routes ?? []) {
          _drivingMapLines.add(
            PolylineMapObject(
              mapId: MapObjectId('route $element'),
              polyline: Polyline(points: element.geometry),
              strokeColor: Colors.blue,
              strokeWidth: 3,
            ),
          );
          DrivingSectionMetadata drivingSectionMetadata = element.metadata;

          String km = drivingSectionMetadata.weight.distance.text.toString();
          String minutes =
              drivingSectionMetadata.weight.timeWithTraffic.text.toString();

          if (points.length == 2) {
            BlocProvider.of<YandexMapBloc>(context)
              ..add(YandexMapSetBPointMinute(minute: minutes));
          }
        }
        mapObjects = mapObjects.take(2).toList();
        mapObjects.addAll(_drivingMapLines);
      });
    }
  }

  DrivingResultWithSession _getDrivingResultWithSession({
    required Point startPoint,
    required Point endPoint,
  }) {
    var drivingResultWithSession = YandexDriving.requestRoutes(
      points: [
        RequestPoint(
          point: startPoint,
          requestPointType: RequestPointType.wayPoint, // точка начала маршрута
        ),
        RequestPoint(
          point: endPoint,
          requestPointType: RequestPointType.wayPoint, // точка конца маршрута
        ),
      ],
      drivingOptions: const DrivingOptions(
        initialAzimuth: 0,
        routesCount: 1,
        avoidTolls: true,
        avoidPoorConditions: true,
      ),
    );

    return drivingResultWithSession;
  }

  Future<void> getCurrentLocation() async {
    var coordinate = await Geolocator.getCurrentPosition();

    _moveToCurrentLocation(coordinate, false);
  }

  Future<void> _moveToCurrentLocation(location, isYandex,
      {bool? fullShow}) async {
    log('must move camera');
    (await yandexMapController.future).moveCamera(
      animation: const MapAnimation(type: MapAnimationType.smooth, duration: 2),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: (isYandex == false)
              ? Point(
                  latitude: location.latitude, longitude: location.longitude)
              : location,
          zoom: (fullShow == true) ? 14 : 15,
        ),
      ),
    );
  }

  void clearObjects() {
    mapObjects.clear();
    points.clear();
    _drivingResultWithSession = null;
    _drivingMapLines.clear();
    setState(() {});
  }

  void addOrderInfo(location, text) {
    final myLocationMarker = PlacemarkMapObject(
      mapId: const MapObjectId('info'),
      opacity: 1,
      text: PlacemarkText(
          text: text, style: PlacemarkTextStyle(size: 44, color: Colors.black)),
      point: Point(latitude: location.latitude, longitude: location.longitude),
    );
    mapObjects.add(myLocationMarker);
    setState(() {});
  }

  void addMapObject(location, isA, {bool isCar = false}) {
    if (isA) {
      final myLocationMarker = PlacemarkMapObject(
        mapId: const MapObjectId('pointA'),
        opacity: 1,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
              scale: (!isCar) ? 0.8 : 0.3,
              rotationType: RotationType.noRotation,
              image: (!isCar)
                  ? BitmapDescriptor.fromAssetImage(
                      'assets/icons/location_logo.png',
                    )
                  : BitmapDescriptor.fromAssetImage(
                      'assets/icons/car_top.png',
                    )),
        ),
        point:
            Point(latitude: location.latitude, longitude: location.longitude),
      );
      if (mapObjects.length == 0) {
        mapObjects.add(myLocationMarker);
      } else {
        mapObjects[0] = myLocationMarker;
      }
      setState(() {});
    } else {
      final myLocationMarker = PlacemarkMapObject(
        mapId: const MapObjectId('pointB'),
        opacity: 1,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
              scale: (!isCar) ? 0.8 : 0.3,
              rotationType: RotationType.rotate,
              image: (!isCar)
                  ? BitmapDescriptor.fromAssetImage(
                      'assets/icons/location_logo.png',
                    )
                  : BitmapDescriptor.fromAssetImage(
                      'assets/icons/car_top.png',
                    )),
        ),
        point:
            Point(latitude: location.latitude, longitude: location.longitude),
      );
      if (mapObjects.length == 1) {
        mapObjects.add(myLocationMarker);
      } else if (mapObjects.length > 1) {
        mapObjects[1] = myLocationMarker;
      }
      setState(() {});
    }
  }
}
