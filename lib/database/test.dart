
import 'package:flutter/cupertino.dart';
import 'package:pizza_rush/database/constants/default_address.dart';
import 'package:pizza_rush/database/wrappers_custom/pizza_order_details.dart';
import 'package:pizza_rush/database/wrappers_join/drink_details.dart';
import 'package:pizza_rush/database/wrappers_table/address.dart';
import 'package:pizza_rush/database/wrappers_table/drink_order.dart';
import 'package:pizza_rush/database/wrappers_table/pizza_order.dart';
import 'package:pizza_rush/database/wrappers_table/user_order.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'constants/default_users.dart';
import 'database_helper.dart';


Future<void> database() async {

  final dbPath = await getDatabasesPath();
  print("📂 SQLite database path: $dbPath");

  WidgetsFlutterBinding.ensureInitialized();
  Database db = await DatabaseHelper.getDatabase();
  print("END");

  int orderId = await UserOrder.addOrder(
      requestTime: DateTime.now().millisecondsSinceEpoch,
      fkUser: DefaultUsers.visitor.id,
      fkAddress: DefaultAddress.placeholder.id
  );


  DrinkOrder.addDrinkToOrder(orderId: orderId, price: 5.00, drinkPriceId: 0);
  final flavorPercentageMap = {
    0: FlavorConfig(50, 0),
    1: FlavorConfig(50, 1),
    2: FlavorConfig(50, 1)
  };

  PizzaOrder.addPizzaToOrder(fkOrder: orderId, price: 30.00, flavorPriceToPercentageMap: flavorPercentageMap);

  UserOrder.update(
      orderId: orderId,
      requestTime: DateTime.now(),
      confirmationTime: DateTime.now(),
      deliveryTime: DateTime.now(),
      primaryContactName: 'Jose',
      primaryContactPhone: '3000 0001'
  );

  print("here");


  List<UserOrder> orders = await UserOrder.getUserOrders(DefaultUsers.visitor.id);
  print(orders);



  for (var order in orders) {
    print("ORDER NEW");
    List<PizzaOrderDetailsEntry> pizzas = await PizzaOrderDetailsEntry.getAllPizzaEntries(order.id);
    for (var p in pizzas) {
      print('PIZZA');
      for(var i in p.details) {
        print(i);
        print('${i.name}: ${i.percentage}');
      }
    }
    List<DrinkDetails> drinks = await DrinkDetails.getAllDrinkDetails(order.id);
    for (var d in drinks) {
      print(d.name);
    }

    final address = await SqlAddress.getAddressesForUserOrder(order.id);
    print('ADDRESS: ${address.line1}');


  }

}

