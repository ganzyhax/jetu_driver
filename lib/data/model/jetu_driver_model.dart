class JetuDriverModel {
  JetuDriverModel({
    this.id,
    this.name,
    this.surname,
    this.status,
    this.phone,
    this.rating,
    this.avatarUrl,
    this.carModel,
    this.carColor,
    this.carNumber,
    this.lat,
    this.long,
    this.isVerified,
    this.token,
    this.amount = 0,
  });

  final String? id;
  final String? name;
  final String? surname;
  final String? status;
  final String? phone;
  final String? token;
  final double? rating;
  final String? avatarUrl;
  final String? carModel;
  final String? carColor;
  final String? carNumber;
  final double? lat;
  final double? long;
  final bool? isVerified;
  final double amount;

  JetuDriverModel.fromJson(Map<String, dynamic> data, {String name = ''})
      : id = name.isNotEmpty ? data[name]['id'] : data['id'],
        name = name.isNotEmpty ? data[name]['name'] : data['name'],
        surname = name.isNotEmpty ? data[name]['surname'] : data['surname'],
        status = name.isNotEmpty ? data[name]['status'] : data['status'],
        phone = name.isNotEmpty ? data[name]['phone'] : data['phone'],
        token = name.isNotEmpty ? data[name]['token'] : data['token'],
        rating = name.isNotEmpty
            ? data[name]['rating'] != null
                ? double.parse(data[name]['rating'].toString())
                : data['rating'] != null
                    ? double.parse(data['rating'].toString())
                    : 0.0
            : 0.0,
        avatarUrl =
            name.isNotEmpty ? data[name]['avatar_url'] : data['avatar_url'],
        carModel =
            name.isNotEmpty ? data[name]['car_model'] : data['car_model'],
        carColor =
            name.isNotEmpty ? data[name]['car_color'] : data['car_color'],
        carNumber =
            name.isNotEmpty ? data[name]['car_number'] : data['car_number'],
        lat = name.isNotEmpty ? data[name]['lat'] : data['lat'],
        long = name.isNotEmpty ? data[name]['long'] : data['long'],
        isVerified =
            name.isNotEmpty ? data[name]['is_verified'] : data['is_verified'],
        amount = name.isNotEmpty
            ? double.parse('${data[name]['amount'] ?? 0.0}')
            : double.parse('${data['amount'] ?? 0.0}');
}

class JetuDriverList {
  final List<JetuDriverModel> users;

  JetuDriverList.fromUserJson(Map<String, dynamic> data, {String? name})
      : users = (data[name ?? "jetu_drivers"] as List)
            .map((e) => JetuDriverModel.fromJson(e))
            .toList();
}
