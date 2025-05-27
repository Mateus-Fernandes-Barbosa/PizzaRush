import 'package:sqflite/sqflite.dart';

import 'package:pizza_rush/database/database_helper.dart';
import 'package:pizza_rush/database/database_definitions.dart';
import 'package:pizza_rush/database/names/pizza/order_pizza.dart';
import 'package:pizza_rush/database/names/pizza/pizza_flavor_percentage.dart';

class PizzaOrder {
  static List<String> columns = [
    PizzaOrderNames.id,
    PizzaOrderNames.price,
    PizzaOrderNames.additionalRequests,
  ];

  final Map<String, dynamic> _data;
  PizzaOrder(this._data);

  int get id => PizzaOrderGets.id(_data);
  double get price => PizzaOrderGets.price(_data);
  String? get additionalRequests => PizzaOrderGets.additionalRequests(_data);

  static List<PizzaOrder> fromQuery(List<Map<String, dynamic>> rows) =>
      rows.map((row) => PizzaOrder(row)).toList();

  // Change to ids. Confusing field that does not yield relevant data by itself
  static Future<List<PizzaOrder>> getAllPizzaOrders(int orderId) async {
    final db = await DatabaseHelper.getDatabase();
    var res = await db.query(
      SqlTable.order_pizza.name,
      columns: PizzaOrder.columns,
      where: '${PizzaOrderNames.fkOrder} = ?',
      whereArgs: [orderId],
    );
    return PizzaOrder.fromQuery(res);
  }

  /* Description:
   *   Adds pizza to order. Two informations are need to add the entry:
   *   - Pizza as a whole (its actual requested price, order associated, etc)
   *   - The flavors on which the pizza is associated
   *
   *   The association is done with the id of the pizza_base_price entry
   *   The map argument associated this given id with the percentage in integer ]0,100]
   *   The total expected from the map must be 100, otherwise a broken entry is added
   *
   * TODO: Add clearer structure to represent the mapping
   */
  static Future<void> addPizzaToOrder({
    required int fkOrder,
    required double price,
    String? additionalRequests,
    required Map<int, FlavorConfig> flavorPriceToPercentageMap,
  }) async {
    Database db = await DatabaseHelper.getDatabase();

    int orderPizzaId = await db.insert(SqlTable.order_pizza.name, {
      PizzaOrderNames.fkOrder: fkOrder,
      PizzaOrderNames.price: price,
      PizzaOrderNames.additionalRequests: additionalRequests,
    });

    final batch = db.batch();
    flavorPriceToPercentageMap.forEach((fkFlavorPrice, tuple) {
      int percentage = tuple.percentage;
      int fkPizzaBorder = tuple.borderId;
      batch.insert(SqlTable.pizza_flavor_percentage.name, {
        PizzaFlavorPercentageNames.percentage: percentage,
        PizzaFlavorPercentageNames.fkPizzaBorder: fkPizzaBorder,
        PizzaFlavorPercentageNames.fkFlavorPrice: fkFlavorPrice,
        PizzaFlavorPercentageNames.fkOrderPizza: orderPizzaId,
      });
    });

    await batch.commit(noResult: true);
  }
}

class FlavorConfig {
  final int percentage;
  final int borderId;

  FlavorConfig(this.percentage, this.borderId);
}
