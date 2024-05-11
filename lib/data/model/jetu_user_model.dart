class JetuUserModel {
  JetuUserModel({
    this.id,
    this.name,
    this.surname,
    this.phone,
    this.email,
    this.rating,
    this.avatarUrl,
    this.token,
  });

  final String? id;
  final String? name;
  final String? surname;
  final String? phone;
  final String? email;
  final double? rating;
  final String? avatarUrl;
  final String? token;

  JetuUserModel.fromJson(Map<String, dynamic> data, {String name = ''})
      : id = name.isNotEmpty ? data[name]['id'] : data['id'],
        name = name.isNotEmpty ? data[name]['name'] : data['name'],
        surname = name.isNotEmpty ? data[name]['surname'] : data['surname'],
        phone = name.isNotEmpty ? data[name]['phone'] : data['phone'],
        email = name.isNotEmpty ? data[name]['email'] : data['email'],
        token = name.isNotEmpty ? data[name]['token'] : data['token'],
        rating = name.isNotEmpty
            ? data[name]['rating'] != null
                ? double.parse(data[name]['rating'].toString())
                : data['rating'] != null
                    ? double.parse(data['rating'].toString())
                    : 0.0
            : 0.0,
        avatarUrl =
            name.isNotEmpty ? data[name]['avatarUrl'] : data['avatarUrl'];
}
