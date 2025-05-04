import 'package:pizza_rush/database/internal/pizza/pizza_flavor.dart';
import 'package:pizza_rush/database/internal/user.dart';
import 'package:sqflite/sqflite.dart';

import 'internal/address.dart';
import 'internal/database_definitions.dart';
import 'internal/database_helper.dart';
import 'internal/drink/order_drink.dart';
import 'internal/pizza/order_pizza.dart';
import 'internal/pizza/pizza_flavor_percentage.dart';
import 'internal/user_order.dart';

class OrderSqlService {
  // CRUD ON USER
  // UPDATING ADDRESS
  static Future<List<UserOrder>> getOrders(int userId) async {
    final db = await DatabaseHelper.getDatabase();
    var res = await db.query(
      SqlTable.user_order.name,
      where: '${UserOrderNames.fkUser} = ?',
      whereArgs: [userId],
    );
    return UserOrder.fromQueryResult(res);
  }

  // ------------------------------------------------------
  // During selection menu

  static Future<int> addOrder({
    required int requestTime,
    required int fkUser
  }) async {
    Database db = await DatabaseHelper.getDatabase();
    return await db.insert(
        SqlTable.user_order.name, 
        {UserOrderNames.requestTime: requestTime, UserOrderNames.fkUser: fkUser}
    );
  }



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


  static Future<void> addPizzaToOrder({
    required int fkOrder,
    required double price,
    String? additionalRequests,
    required Map<int, int> flavorPercentageMap,

  }) async {
    Database db = await DatabaseHelper.getDatabase();

    int orderPizzaId = await db.insert(SqlTable.order_pizza.name, {
      PizzaOrderNames.fkOrder: fkOrder,
      PizzaOrderNames.price: price,
      PizzaOrderNames.additionalRequests: additionalRequests
    });

    final batch = db.batch();
    flavorPercentageMap.forEach((fkFlavorPrice, percentage) {
      batch.insert(SqlTable.pizza_flavor_percentage.name, {
        PizzaFlavorPercentageNames.percentage: percentage,
        PizzaFlavorPercentageNames.fkFlavorPrice: fkFlavorPrice,
        PizzaFlavorPercentageNames.fkOrderPizza: orderPizzaId,
      });
    });

    await batch.commit(noResult: true);
  }

  // ------------------------------------------------------
  // During confirmation menu
  static Future<void> updateRequestTime({
    required int orderId,
    required DateTime time,
  }) async {
    final db = await DatabaseHelper.getDatabase();

    final Map<String, Object?> updates = {};
    updates[UserOrderNames.requestTime] = time;

    if (updates.isNotEmpty) {
      await db.update(
        SqlTable.user_order.name,
        updates,
        where: 'id = ?',
        whereArgs: [orderId],
      );
    }
  }

  static Future<void> updateConfirmationTime({
    required int orderId,
    required DateTime time,
  }) async {
    final db = await DatabaseHelper.getDatabase();

    final Map<String, Object?> updates = {};
    updates[UserOrderNames.confirmationTime] = time;

    if (updates.isNotEmpty) {
      await db.update(
        SqlTable.user_order.name,
        updates,
        where: 'id = ?',
        whereArgs: [orderId],
      );
    }
  }

  static Future<void> updateConclusionTime({
    required int orderId,
    required DateTime time,
  }) async {
    final db = await DatabaseHelper.getDatabase();

    final Map<String, Object?> updates = {};
    updates[UserOrderNames.confirmationTime] = time;

    if (updates.isNotEmpty) {
      await db.update(
        SqlTable.user_order.name,
        updates,
        where: 'id = ?',
        whereArgs: [orderId],
      );
    }
  }

  //------------------------------------------------

  static Future<List<Map<String, dynamic>>> getOrderPizzas(int orderId) async {
    final db = await DatabaseHelper.getDatabase();

    final pizzaFlavorName = '''${SqlTable.pizza_flavor.name}.${PizzaFlavorNames.name}''';
    final pizzaFlavorPercentage = '''${SqlTable.pizza_flavor_percentage.name}.${PizzaFlavorPercentageNames.percentage}''';

    var map = await db.rawQuery('''
      SELECT ${SqlTable.pizza_flavor}.${PizzaFlavorNames.name}, flavor_percent.name, pizza_order.description
      FROM flavor_percent
      JOIN pizza_order ON pizza_order.id = flavor_percent.fk_pizza_order
      WHERE pizza_order.id = ?
    ''', [orderId]);

    return map;
  }

}