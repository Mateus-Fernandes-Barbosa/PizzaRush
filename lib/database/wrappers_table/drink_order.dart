import 'package:sqflite/sqflite.dart';

import 'package:pizza_rush/database/database_helper.dart';
import 'package:pizza_rush/database/database_definitions.dart';
import 'package:pizza_rush/database/names/drink/order_drink.dart';


class DrinkOrder {
  static Future<int> addDrinkToOrder({
    required int orderId,
    required double price,
    required int drinkPriceId,
  }) async {
    Database db = await DatabaseHelper.getDatabase();
    return await db.insert(SqlTable.order_drink.name, {
      OrderDrinkNames.fkOrder: orderId,
      OrderDrinkNames.price: price,
      OrderDrinkNames.fkDrinkInstance: drinkPriceId,
    });
  }
}