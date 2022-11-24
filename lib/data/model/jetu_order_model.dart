import 'package:jetu.driver/data/model/jetu_driver_model.dart';
import 'package:jetu.driver/data/model/jetu_user_model.dart';
import 'package:latlong2/latlong.dart';

class JetuOrderModel {
  JetuOrderModel({
    required this.id,
    this.driver,
    this.user,
    this.status,
    this.cost,
    this.comment,
    this.createdAt,
    this.aPointLat,
    this.aPointLong,
    this.bPointLat,
    this.bPointLong,
    this.aPointAddress,
    this.bPointAddress,
    this.service,
  });

  final String id;
  final JetuDriverModel? driver;
  final JetuUserModel? user;
  final String? status;
  final String? cost;
  final String? comment;
  final DateTime? createdAt;
  final double? aPointLat;
  final double? aPointLong;
  final double? bPointLat;
  final double? bPointLong;
  final String? aPointAddress;
  final String? bPointAddress;
  final ServiceModel? service;

  LatLng aPoint() => LatLng(this.aPointLat ?? 0.0, this.aPointLong ?? 0.0);

  LatLng bPoint() => LatLng(this.bPointLat ?? 0.0, this.bPointLong ?? 0.0);

  JetuOrderModel.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        driver = data['jetu_driver'] != null
            ? JetuDriverModel.fromJson(data['jetu_driver'])
            : null,
        user = data['jetu_user'] != null
            ? JetuUserModel.fromJson(data['jetu_user'])
            : null,
        status = data['status'],
        cost = data['cost'],
        comment = data['comment'],
        createdAt = DateTime.parse(data['created_at']).toLocal(),
        aPointLat = data['point_a_lat'] != null
            ? double.parse(data['point_a_lat'].toString())
            : null,
        aPointLong = data['point_a_long'] != null
            ? double.parse(data['point_a_long'].toString())
            : null,
        bPointLat = data['point_b_lat'] != null
            ? double.parse(data['point_b_lat'].toString())
            : null,
        bPointLong = data['point_b_long'] != null
            ? double.parse(data['point_b_long'].toString())
            : null,
        aPointAddress =
            data['point_a_address'] != null ? data['point_a_address'] : null,
        bPointAddress =
            data['point_b_address'] != null ? data['point_b_address'] : null,
        service = data['jetu_service'] != null
            ? ServiceModel.fromJson(data['jetu_service'])
            : null;
}

class JetuOrderList {
  final List<JetuOrderModel> orders;

  JetuOrderList.fromUserJson(Map<String, dynamic> data, {String? name})
      : orders = (data[name ?? "jetu_orders"] as List)
            .map((e) => JetuOrderModel.fromJson(e))
            .toList();
}

class ServiceModel {
  ServiceModel({this.id, this.title});

  final String? id;
  final String? title;

  ServiceModel.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'];
}

enum OrderStatus {
  requested,
  canceled,
  driverAccept,
  finished,
}
