class JetuServicesModel {
  JetuServicesModel({
    this.id,
    this.title,
    this.icon,
    this.info,
  });

  final String? id;
  final String? title;
  final String? icon;
  final String? info;

  JetuServicesModel.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        icon = data['icon_assets'],
        info = data['info'];
}

class JetuServicesList {
  final List<JetuServicesModel> services;

  JetuServicesList.fromUserJson(Map<String, dynamic> data)
      : services = (data["jetu_services"] as List)
            .map((e) => JetuServicesModel.fromJson(e))
            .toList();
}
