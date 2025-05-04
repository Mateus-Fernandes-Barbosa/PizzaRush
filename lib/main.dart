import 'package:flutter/material.dart';
import 'package:pizza_rush/database/internal/database_definitions.dart';
import 'package:pizza_rush/database/internal/language.dart';
import 'package:pizza_rush/database/order_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'database/internal/database_helper.dart';
import 'main_screen.dart';

Future<void> database() async {
  // Initialize FFI (required on desktop or Dart CLI)
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final dbPath = await getDatabasesPath();
  print("📂 SQLite database path: $dbPath");

  WidgetsFlutterBinding.ensureInitialized();
  Database db = await DatabaseHelper.getDatabase();
  print("END");

  int order = await OrderSqlService.addOrder(requestTime: DateTime.now().millisecondsSinceEpoch, fkUser: 0);
  OrderSqlService.addDrinkToOrder(orderId: order, price: 5.00, drinkPriceId: 0);
  final flavorPercentageMap = {
    0: 50,
    1: 25,
    2: 25
  };
  OrderSqlService.addPizzaToOrder(fkOrder: order, price: 30.00, flavorPercentageMap: flavorPercentageMap);
}


void main() {
  runApp(MainScreen());
}