import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../database_helper.dart';
import '../database_definitions.dart';
import 'pizza_flavor_percentage.dart';



class PizzaOrderNames {
  static const String id = 'id';
  static const String fkOrder = 'fk_user_order';
  static const String additionalRequests = 'additional_requests';
  static const String price = 'price';
}


class PizzaOrder {
  final Map<String, dynamic> _data;
  PizzaOrder(this._data);

  int get id => _data[PizzaOrderNames.id] as int;
  int get fkOrder => _data[PizzaOrderNames.fkOrder] as int;
  String? get additionalRequests => _data[PizzaOrderNames.additionalRequests] as String?;
  double get price => _data[PizzaOrderNames.fkOrder] as double;
  
  Map<String, dynamic> toMap() => _data;

  @override
  String toString() {
    return 'UserOrder(id: $id, fk_order: $fkOrder)';
  }

  static List<PizzaOrder> fromQueryResult(List<Map<String, dynamic>> rows) {
    return rows.map((row) => PizzaOrder(row)).toList();
  }
}



