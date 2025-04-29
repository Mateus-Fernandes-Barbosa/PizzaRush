import 'package:flutter/material.dart';
import 'main_screen.dart';

class Sabor {
  final String nome;
  final String imagem;

  Sabor({Key? key, required this.nome, required this.imagem});
}

class ManagingOrder extends StatelessWidget {
  late int quantityFlavors;

  ManagingOrder({Key? key, required this.quantityFlavors});

  @override
  Widget build(BuildContext context) {
    return _ManagingOrder(quantityFlavors: quantityFlavors);
  }
}

class _ManagingOrder extends StatefulWidget {
  late int quantityFlavors;

  _ManagingOrder({required this.quantityFlavors});

  @override
  _ManagingOrderState createState() =>
      _ManagingOrderState(quantityFlavors: quantityFlavors);
}

class _ManagingOrderState extends State<_ManagingOrder> {
  List<Sabor> sabores = [
    Sabor(nome: "Calabresa", imagem: 'lib/assets/images/calabresa.jpg'),
  ];

  final int quantityFlavors;

  _ManagingOrderState({required this.quantityFlavors});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${quantityFlavors} Sabores')),
      body: ListView.builder(
        itemCount: quantityFlavors, // Cria uma lista para cada sabor
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${index + 1}º Sabor",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap:
                    true, // Permite que o ListView interno funcione corretamente
                physics:
                    NeverScrollableScrollPhysics(), // Desativa a rolagem do ListView interno
                itemCount: sabores.length, // Exibe os sabores em cada lista
                itemBuilder: (context, innerIndex) {
                  final sabor = sabores[innerIndex];
                  return ListTile(
                    leading: SizedBox(
                      child: Image.asset(
                        sabor.imagem, 
                        fit: BoxFit.cover),
                    ),
                    title: Text(sabor.nome),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
