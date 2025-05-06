import '../names/user_order.dart';

class UserOrder {
  static List<String> columns = [
    UserOrderNames.id,
    UserOrderNames.requestTime,
    UserOrderNames.confirmationTime,
    UserOrderNames.deliveryTime
  ];

  final Map<String, dynamic> _data;
  UserOrder(this._data);

  int get id => UserOrderGets.id(_data);
  DateTime? get requestTimeDateTime => UserOrderGets.requestTimeDateTime(_data);
  DateTime? get confirmationTimeDateTime => UserOrderGets.confirmationTimeDateTime(_data);
  DateTime? get deliveryTimeDateTime => UserOrderGets.deliveryTimeDateTime(_data);
  int? get requestTimeUnix => UserOrderGets.requestTimeUnix(_data);
  int? get confirmTimeUnix => UserOrderGets.confirmationTimeUnix(_data);
  int? get deliveryTimeUnix => UserOrderGets.deliveryTimeUnix(_data);

  //int get fkUser => UserOrderGets.fkUser(_data); NOT NEEDED


  Map<String, dynamic> toMap() => _data;

  @override
  String toString() =>
      'UserOrder(id: $id, requestTime: $requestTimeDateTime, confirmationTime: $confirmationTimeDateTime, '
          'deliveryTime: $deliveryTimeDateTime)';

  static List<UserOrder> fromQuery(List<Map<String, dynamic>> rows) =>
      rows.map((row) => UserOrder(row)).toList();
}
