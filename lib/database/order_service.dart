import 'package:flutter/cupertino.dart';
import 'package:pizza_rush/database/constants/drink_dummy.dart';
import 'package:pizza_rush/database/names/address.dart';
import 'package:pizza_rush/database/names/drink/drink.dart';
import 'package:pizza_rush/database/names/drink/drink_price.dart';
import 'package:pizza_rush/database/names/pizza/pizza_flavor_price.dart';
import 'package:pizza_rush/database/wrappers_custom/pizza_order_details.dart';
import 'package:pizza_rush/database/wrappers_join/drink_details.dart';
import 'package:pizza_rush/database/wrappers_join/pizza_details.dart';
import 'package:pizza_rush/database/wrappers_table//pizza_order.dart';
import 'package:pizza_rush/database/wrappers_table/user_order.dart';
import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';
import 'names/address.dart';
import 'database_definitions.dart';
import 'names/drink/order_drink.dart';
import 'names/pizza/order_pizza.dart';
import 'names/pizza/pizza_flavor.dart';
import 'names/pizza/pizza_flavor_percentage.dart';
import 'names/user_order.dart';




/* Description:
 *   Manages adding user orders, alongside adding drinks, pizza
 *   Also manages retrieval of data in safe and organized manner
 *
 * Warning:
 *   Some of the returns include the response as map, and there
 *   is no limit mechanism. Proper data handling is to be done if data
 *   stored scales
 */
class OrderSqlService {

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
    required Map<int, int> flavorPriceToPercentageMap,

  }) async {
    Database db = await DatabaseHelper.getDatabase();

    int orderPizzaId = await db.insert(SqlTable.order_pizza.name, {
      PizzaOrderNames.fkOrder: fkOrder,
      PizzaOrderNames.price: price,
      PizzaOrderNames.additionalRequests: additionalRequests
    });

    final batch = db.batch();
    flavorPriceToPercentageMap.forEach((fkFlavorPrice, percentage) {
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
        where: '${UserOrderNames.id} = ?',
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
        where: '${UserOrderNames.id} = ?',
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
        where: '${UserOrderNames.id} = ?',
        whereArgs: [orderId],
      );
    }
  }

  //------------------------------------------------

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



  //------------------------------------------------
  // PIZZA ORDER

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

  // TODO: Join query with list of all pizzaOrders could be more optimized
  static Future<List<PizzaDescription>> _getSinglePizzaDetails(int pizzaOrder) async {
    final db = await DatabaseHelper.getDatabase();


    String selectQuery = '''
      percentage.${PizzaFlavorPercentageNames.percentage} AS ${PizzaDescriptionNames.percentage},
      price.${PizzaFlavorPriceNames.priceSmall} AS ${PizzaDescriptionNames.priceSmall},
      price.${PizzaFlavorPriceNames.priceMedium} AS ${PizzaDescriptionNames.priceMedium},
      price.${PizzaFlavorPriceNames.priceLarge} AS ${PizzaDescriptionNames.priceLarge},
      flavor.${PizzaFlavorNames.name} AS ${PizzaDescriptionNames.name},
      flavor.${PizzaFlavorNames.description} AS ${PizzaDescriptionNames.description}
    ''';


    String sql = '''
      SELECT $selectQuery
      FROM ${SqlTable.pizza_flavor_percentage.name} AS percentage
      
      JOIN ${SqlTable.pizza_flavor_price.name} AS price ON 
        percentage.${PizzaFlavorPercentageNames.fkFlavorPrice} 
        = price.${PizzaFlavorPriceNames.id}
        
      JOIN ${SqlTable.pizza_flavor.name} AS flavor ON 
        price.${PizzaFlavorPriceNames.fkPizzaFlavor} 
        = flavor.${PizzaFlavorNames.id}
        
      WHERE percentage.${PizzaFlavorPercentageNames.fkOrderPizza} = ?
    ''';


    //debugPrint(sql);

    var map = await db.rawQuery(sql, [pizzaOrder]);
    return PizzaDescription.fromQuery(map);
  }

  static Future<List<PizzaOrderDetailsEntry>> getAllPizzaDetails(int orderId) async {
    final db = await DatabaseHelper.getDatabase();
    var pizzaOrders = await getAllPizzaOrders(orderId);
    
    List<PizzaOrderDetailsEntry> list = [];
    for (var order in pizzaOrders) {
      int id = order.id;
      var details = await _getSinglePizzaDetails(id);
      list.add(PizzaOrderDetailsEntry(order.price, order.additionalRequests, details));
    }
    return list;
  }

  //------------------------------------------------
  // DRINK ORDER

  static Future<List<DrinkDetails>> getAllDrinkDetails(int orderId) async {
    final db = await DatabaseHelper.getDatabase();

    String selectQuery = '''
      od.${OrderDrinkNames.price} AS ${DrinkDescriptionNames.name},
      price.${DrinkBasePriceNames.price} AS ${DrinkDescriptionNames.basePrice},
      drink.${DrinkNames.description} AS ${DrinkDescriptionNames.description},
      drink.${DrinkNames.brand} AS ${DrinkDescriptionNames.brand},
      drink.${DrinkNames.name} AS ${DrinkDescriptionNames.name}
    ''';

    String sql = '''
      SELECT $selectQuery
      FROM ${SqlTable.order_drink.name} AS od
      
      JOIN ${SqlTable.drink_price.name} AS price ON 
        price.${DrinkBasePriceNames.id} 
        = od.${OrderDrinkNames.fkDrinkInstance}
      
      JOIN ${SqlTable.drink.name} AS drink ON 
        price.${DrinkBasePriceNames.fkDrink} 
        = drink.${DrinkNames.id}
        
      WHERE od.${OrderDrinkNames.fkOrder} = ?
    ''';

    //debugPrint(sql);

    var map = await db.rawQuery(sql, [orderId]);
    return DrinkDetails.fromQuery(map);
  }
}
