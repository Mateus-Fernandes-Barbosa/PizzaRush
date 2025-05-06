
import 'package:flutter/cupertino.dart';
import 'package:pizza_rush/database/wrappers_custom/pizza_order_details.dart';
import 'package:pizza_rush/database/wrappers_join/drink_details.dart';
import 'package:pizza_rush/database/wrappers_table/user_order.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'constants/default_users.dart';
import 'database_helper.dart';
import 'order_service.dart';

Future<void> database() async {
  // Initialize FFI (required on desktop or Dart CLI)
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final dbPath = await getDatabasesPath();
  print("📂 SQLite database path: $dbPath");

  WidgetsFlutterBinding.ensureInitialized();
  Database db = await DatabaseHelper.getDatabase();
  print("END");

  // int order = await OrderSqlService.addOrder(requestTime: DateTime.now().millisecondsSinceEpoch, fkUser: 0);
  // OrderSqlService.addDrinkToOrder(orderId: order, price: 5.00, drinkPriceId: 0);
  // final flavorPercentageMap = {
  //   0: 50,
  //   1: 25,
  //   2: 25
  // };
  // OrderSqlService.addPizzaToOrder(fkOrder: order, price: 30.00, flavorPercentageMap: flavorPercentageMap);

  List<UserOrder> orders = await OrderSqlService.getUserOrders(DefaultUsers.visitor.id);
  print (orders);



  for (var order in orders) {
    List<PizzaOrderDetailsEntry> pizzas = await OrderSqlService.getAllPizzaDetails(order.id);
    for (var p in pizzas) {
      print('PIZZA');
      for(var i in p.details) {
        print('${i.name}: ${i.percentage}');
      }
    }
    List<DrinkDetails> drinks = await OrderSqlService.getAllDrinkDetails(order.id);
    for (var d in drinks) {
      print(d.name);
    }

  }

}

