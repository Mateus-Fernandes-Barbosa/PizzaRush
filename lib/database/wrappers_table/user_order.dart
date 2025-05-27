import 'package:sqflite/sqflite.dart';

import 'package:pizza_rush/database/database_definitions.dart';
import 'package:pizza_rush/database/database_helper.dart';
import 'package:pizza_rush/database/names/user_order.dart';

class UserOrder {
  static List<String> columns = [
    UserOrderNames.id,
    UserOrderNames.requestTime,
    UserOrderNames.confirmationTime,
    UserOrderNames.deliveryTime,
    UserOrderNames.fkAddress,
    UserOrderNames.primaryContactName,
    UserOrderNames.primaryContactPhone,
    UserOrderNames.primaryContactObservations,
    UserOrderNames.totalAmount,
    UserOrderNames.paymentMethod,
  ];

  final Map<String, dynamic> _data;
  UserOrder(this._data);

  int get id => UserOrderGets.id(_data);
  DateTime get requestTimeDateTime => UserOrderGets.requestTimeDateTime(_data);
  DateTime get confirmationTimeDateTime =>
      UserOrderGets.confirmationTimeDateTime(_data);
  DateTime get deliveryTimeDateTime =>
      UserOrderGets.deliveryTimeDateTime(_data);
  int get requestTimeUnix => UserOrderGets.requestTimeUnix(_data);
  int get confirmTimeUnix => UserOrderGets.confirmationTimeUnix(_data);
  int get deliveryTimeUnix => UserOrderGets.deliveryTimeUnix(_data);
  String get primaryContactName => UserOrderGets.primaryContactName(_data);
  String get primaryContactPhone => UserOrderGets.primaryContactPhone(_data);
  String? get primaryContactObservations =>
      UserOrderGets.primaryContactObservations(_data);
  double? get totalAmount => UserOrderGets.totalAmount(_data);
  String? get paymentMethod => UserOrderGets.paymentMethod(_data);
  int get fkAddress => UserOrderGets.fkAddress(_data);

  //int get fkUser => UserOrderGets.fkUser(_data); NOT NEEDED

  Map<String, dynamic> toMap() => _data;

  @override
  String toString() =>
      'UserOrder(id: $id, requestTime: $requestTimeDateTime, confirmationTime: $confirmationTimeDateTime, '
      'deliveryTime: $deliveryTimeDateTime)';

  static List<UserOrder> fromQuery(List<Map<String, dynamic>> rows) =>
      rows.map((row) => UserOrder(row)).toList();

  static Future<List<UserOrder>> getUserOrders(int userId) async {
    final db = await DatabaseHelper.getDatabase();
    var res = await db.query(
      SqlTable.user_order.name,
      columns: UserOrder.columns,
      where: '${UserOrderNames.fkUser} = ?',
      whereArgs: [userId],
    );
    return UserOrder.fromQuery(res);
  }

  // Allow loose inserts
  // Maybe not the best, but its like this for now
  static Future<int> addOrder({
    required int requestTime,
    required int fkUser,
    required int fkAddress,
  }) async {
    Database db = await DatabaseHelper.getDatabase();
    return await db.insert(SqlTable.user_order.name, {
      UserOrderNames.requestTime: requestTime,
      UserOrderNames.fkUser: fkUser,
      UserOrderNames.fkAddress: fkAddress,
    });
  }

  static Future<void> update({
    required int orderId,
    required DateTime requestTime,
    required DateTime confirmationTime,
    required DateTime deliveryTime,
    required String primaryContactName,
    required String primaryContactPhone,
    String? primaryContactObservations,
  }) async {
    final db = await DatabaseHelper.getDatabase();

    final Map<String, Object?> updates = {};
    updates[UserOrderNames.requestTime] = requestTime.millisecondsSinceEpoch;
    updates[UserOrderNames.confirmationTime] =
        confirmationTime.millisecondsSinceEpoch;
    updates[UserOrderNames.deliveryTime] = deliveryTime.millisecondsSinceEpoch;
    updates[UserOrderNames.primaryContactName] = primaryContactName;
    updates[UserOrderNames.primaryContactPhone] = primaryContactPhone;
    if (primaryContactObservations != null) {
      updates[UserOrderNames.primaryContactObservations] =
          primaryContactObservations;
    }

    if (updates.isNotEmpty) {
      await db.update(
        SqlTable.user_order.name,
        updates,
        where: '${UserOrderNames.id} = ?',
        whereArgs: [orderId],
      );
    }
  }
}
