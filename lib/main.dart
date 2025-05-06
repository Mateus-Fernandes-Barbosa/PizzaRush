import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pizza_rush/database/test.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'database/internal/database_helper.dart';
// import 'database/order_service.dart';
import 'main_screen.dart';

// Future<void> database() async {
//   // Initialize FFI (required on desktop or Dart CLI)
//   sqfliteFfiInit();
//   databaseFactory = databaseFactoryFfi;

//   final dbPath = await getDatabasesPath();
//   print("📂 SQLite database path: $dbPath");

//   WidgetsFlutterBinding.ensureInitialized();
//   Database db = await DatabaseHelper.getDatabase();
//   print("END");

//   int order = await OrderSqlService.addOrder(requestTime: DateTime.now().millisecondsSinceEpoch, fkUser: 0);
//   OrderSqlService.addDrinkToOrder(orderId: order, price: 5.00, drinkPriceId: 0);
//   final flavorPercentageMap = {
//     0: 50,
//     1: 25,
//     2: 25
//   };
//   OrderSqlService.addPizzaToOrder(fkOrder: order, price: 30.00, flavorPercentageMap: flavorPercentageMap);
// }


void main() async {
  // Garante que as widgets estão inicializadas
  database();
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Stripe para Android e iOS
  if (Platform.isAndroid || Platform.isIOS) {
    Stripe.publishableKey = 'CHAVE_PUBLICAVEL';
    await Stripe.instance.applySettings();
  }

  // Inicializa o aplicativo
  runApp(PizzaRushApp());
}

class PizzaRushApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Rush',
      theme: ThemeData(
        primarySwatch: Colors.red,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

