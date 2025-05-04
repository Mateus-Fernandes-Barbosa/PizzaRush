import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'main_screen.dart';

void main() async {
  // Garante que as widgets estão inicializadas
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o Stripe - Substitua com sua chave publishable real quando estiver em produção
  Stripe.publishableKey = 'pk_test_51RKTqQGdX2861DLQEnFTJ31HtmKYew42HqsuF0CwNCtpXhcYmkAM3AqIRVCLfmG8S8uOcCAe7B9a7R9nftwVOsmz00Kh1nzjiw';
  await Stripe.instance.applySettings();
  
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
