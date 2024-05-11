part of 'yandex_map_bloc.dart';

@immutable
class YandexMapEvent {}

class YandexMapLoad extends YandexMapEvent {}

class YandexMapSetAPoint extends YandexMapEvent {
  List data;
  YandexMapSetAPoint({required this.data});
}

class YandexMapSetBPoint extends YandexMapEvent {
  List data;
  YandexMapSetBPoint({required this.data});
}

class YandexMapSetBPointMinute extends YandexMapEvent {
  String minute;
  YandexMapSetBPointMinute({required this.minute});
}

class YandexMapNewOrderDrow extends YandexMapEvent {
  JetuOrderModel data;
  YandexMapNewOrderDrow({required this.data});
}

class YandexMapClearObject extends YandexMapEvent {
  bool withLoad;
  YandexMapClearObject({required this.withLoad});
}

class YandexMapDriveToClient extends YandexMapEvent {
  JetuOrderModel order;
  YandexMapDriveToClient({required this.order});
}

class YandexMapChangeLocation extends YandexMapEvent {
  int changeType;
  JetuOrderModel? order;
  YandexMapChangeLocation({required this.changeType, this.order});
}

class YandexMapStartDriverTimer extends YandexMapEvent {
  JetuOrderModel? order;
  YandexMapStartDriverTimer({required this.order});
}

class YandexMapOnWayDraw extends YandexMapEvent {
  JetuOrderModel order;
  YandexMapOnWayDraw({required this.order});
}

class YandexMapStartedDraw extends YandexMapEvent {
  JetuOrderModel order;

  YandexMapStartedDraw({
    required this.order,
  });
}

class YandexMapStopLoadTimer extends YandexMapEvent {}

class YandexMapStopOnWayTimer extends YandexMapEvent {}

class YandexMapStopStartTimer extends YandexMapEvent {}

class YandexMapResetTimers extends YandexMapEvent {}
