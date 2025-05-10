import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pizza_rush/database/test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'main_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isLinux || Platform.isWindows)) {
    // Initialize FFI (required on desktop or Dart CLI)
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

  }


  // Inicializa o Stripe para Android e iOS
  if (Platform.isAndroid || Platform.isIOS) {
    Stripe.publishableKey = "pk_test_51RKTqQGdX2861DLQEnFTJ31HtmKYew42HqsuF0CwNCtpXhcYmkAM3AqIRVCLfmG8S8uOcCAe7B9a7R9nftwVOsmz00Kh1nzjiw";
    await Stripe.instance.applySettings();
  }
  database();


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

