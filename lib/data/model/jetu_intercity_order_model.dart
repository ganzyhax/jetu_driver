// import 'package:jetu.driver/data/model/jetu_driver_model.dart';
// import 'package:jetu.driver/data/model/jetu_user_model.dart';
// import 'package:latlong2/latlong.dart';
//
// class JetuInterCityOrderModel {
//   JetuInterCityOrderModel({
//     required this.id,
//     this.driver,
//     this.user,
//     this.status,
//     this.cost,
//     this.comment,
//     this.createdAt,
//     this.aPointLat,
//     this.aPointLong,
//     this.bPointLat,
//     this.bPointLong,
//     this.aPointAddress,
//     this.bPointAddress,
//     this.service,
//   });
//
//   final String id;
//   final JetuDriverModel? driver;
//   final JetuUserModel? user;
//   final String? status;
//   final String? cost;
//   final String? comment;
//   final DateTime? createdAt;
//   final double? aPointLat;
//   final double? aPointLong;
//   final double? bPointLat;
//   final double? bPointLong;
//   final String? aPointAddress;
//   final String? bPointAddress;
//   final ServiceModel? service;
//
//   JetuInterCityOrderModel.fromJson(Map<String, dynamic> data)
//       : id = data['id'],
// }
//
// class JetuOrderList {
//   final List<JetuInterCityOrderModel> orders;
//
//   JetuOrderList.fromUserJson(Map<String, dynamic> data, {String? name})
//       : orders = (data[name ?? "jetu_orders"] as List)
//             .map((e) => JetuInterCityOrderModel.fromJson(e))
//             .toList();
// }
//
// class ServiceModel {
//   ServiceModel({this.id, this.title});
//
//   final String? id;
//   final String? title;
//
//   ServiceModel.fromJson(Map<String, dynamic> data)
//       : id = data['id'],
//         title = data['title'];
// }
//
// enum OrderStatus {
//   requested,
//   canceled,
//   driverAccept,
//   finished,
// }
