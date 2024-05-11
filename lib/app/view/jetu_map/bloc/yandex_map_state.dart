part of 'yandex_map_bloc.dart';

@immutable
class YandexMapState {}

class YandexMapInitial extends YandexMapState {}

class YandexMapLoaded extends YandexMapState {
  List aPoint;
  List bPoint;
  Map<String, dynamic> myLocation;
  bool isPointAChanged;
  YandexMapLoaded(
      {required this.aPoint,
      required this.myLocation,
      required this.bPoint,
      required this.isPointAChanged});
}

class YandexMapLisSetPointA extends YandexMapState {
  bool? isOnlyDriver;
  Point aPoint;
  YandexMapLisSetPointA({required this.aPoint, this.isOnlyDriver = false});
}

// class YandexMapLisClear extends YandexMapState {}

class YandexMapClearObjectList extends YandexMapState {
  bool withLoad;
  YandexMapClearObjectList({required this.withLoad});
}

class YandexMapLisSetPointB extends YandexMapState {
  Point bPoint;
  bool? isCar;
  YandexMapLisSetPointB({required this.bPoint, this.isCar});
}
