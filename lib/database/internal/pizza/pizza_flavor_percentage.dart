import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../database_helper.dart';
import '../database_definitions.dart';



class PizzaFlavorPercentageNames {
  static const String percentage = 'percentage';
  static const String fkFlavorPrice = 'fk_pizza_flavor_price';
  static const String fkOrderPizza = 'fk_order_pizza';
}


class PizzaFlavorPercentage {
  final Map<String, dynamic> _data;
  PizzaFlavorPercentage(this._data);

  //Given as 0 - 100
  int get percentage => _data[PizzaFlavorPercentageNames.percentage] as int;
  int get fkFlavorPrice => _data[PizzaFlavorPercentageNames.fkFlavorPrice] as int;
  int get fkOrderPizza => _data[PizzaFlavorPercentageNames.fkOrderPizza] as int;
  
  Map<String, dynamic> toMap() => _data;

  @override
  String toString() {
    return 'UserOrder(percentage: $percentage, fk_pizza_flavor_price: $fkFlavorPrice, fk_order_pizza: $fkOrderPizza)';
  }

  static List<PizzaFlavorPercentage> fromQueryResult(List<Map<String, dynamic>> rows) {
    return rows.map((row) => PizzaFlavorPercentage(row)).toList();
  }
}




