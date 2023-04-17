class JetuTransactionModel {
  JetuTransactionModel({
    required this.id,
    this.driverId,
    this.amount,
    this.type,
    this.createdAt,
  });

  final String id;
  final String? driverId;
  final double? amount;
  final String? type;
  final DateTime? createdAt;

  JetuTransactionModel.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        driverId = data['driver_id'],
        amount = double.parse('${data['amount'] ?? 0.0}'),
        type = data['type'],
        createdAt =DateTime.parse( data['created_at']);
}

class JetuTransactionList {
  final List<JetuTransactionModel> orders;

  JetuTransactionList.fromUserJson(Map<String, dynamic> data, {String? name})
      : orders = (data[name ?? "transaction"] as List)
            .map((e) => JetuTransactionModel.fromJson(e))
            .toList();
}
