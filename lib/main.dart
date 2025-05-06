import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pizza_rush/database/test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'database/order_service.dart';
import 'main_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



void main() async {
  // Garante que as widgets estão inicializadas
  database();
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Stripe para Android e iOS
  if (Platform.isAndroid || Platform.isIOS) {
    Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
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

