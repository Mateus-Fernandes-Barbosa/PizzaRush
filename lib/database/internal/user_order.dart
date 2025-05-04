import 'package:pizza_rush/database/internal/pizza/order_pizza.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_helper.dart';
import 'database_definitions.dart';
import 'drink/order_drink.dart';



class UserOrderNames {
  static const String id = 'id';
  static final String requestTime = "request_time";
  static final String confirmationTime = "confirmation_time";
  static final String deliveryTime = "delivery_time";
  static final String fkUser = "fk_user";
}


class UserOrder {
  final Map<String, dynamic> _data;
  UserOrder(this._data);

  int get id => _data[UserOrderNames.id] as int;
  DateTime? get requestTime => _data[UserOrderNames.requestTime] as DateTime?;
  DateTime? get confirmationTime => _data[UserOrderNames.confirmationTime] as DateTime?;
  DateTime? get deliveryTime => _data[UserOrderNames.deliveryTime] as DateTime?;
  int get fkUser => _data[UserOrderNames.fkUser] as int;


  Map<String, dynamic> toMap() => _data;

  @override
  String toString() {
    return 'UserOrder(id: $id, user_id: $fkUser, confirmation_time: $confirmationTime)';
  }

  static List<UserOrder> fromQueryResult(List<Map<String, dynamic>> rows) {
    return rows.map((row) => UserOrder(row)).toList();
  }
}



