import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../database_helper.dart';
import '../database_definitions.dart';



class OrderDrinkNames {
  static const String fkOrder = 'fk_user_order';
  static final String fkDrinkInstance = "fk_drink_price";
  static final String price = 'price';
}


class OrderDrink {
  final Map<String, dynamic> _data;
  OrderDrink(this._data);

  int get fkOrder => _data[OrderDrinkNames.fkOrder] as int;
  int get fkDrinkInstance => _data[OrderDrinkNames.fkDrinkInstance] as int;
  double get price => _data[OrderDrinkNames.price] as double;

  Map<String, dynamic> toMap() => _data;

  @override
  String toString() {
    return 'UserOrder(fk_order: $fkOrder, fk_drink_instance: $fkDrinkInstance)';
  }

  static List<OrderDrink> fromQueryResult(List<Map<String, dynamic>> rows) {
    return rows.map((row) => OrderDrink(row)).toList();
  }
}


