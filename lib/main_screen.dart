import 'package:flutter/material.dart';
import 'package:pizza_rush/widgets/navigation_helper.dart';
import 'history.dart';
import 'managing_order_screen.dart';
import 'dart:developer';
import 'map_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: _MainScreen());
  }
}

class _MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<_MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Clique para um novo pedido: ",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManagingOrder(quantityFlavors: 4)
                          )
                        );
                      },
                      child: Text(
                          "Quatro Sabores",
                            style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )

                      )
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ManagingOrder(quantityFlavors: 2)
                            )
                        );
                      },
                      child: Text(
                          "Dois Sabores",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )
                      )
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ManagingOrder(quantityFlavors: 1)
                            )
                        );
                      },
                      child: Text(
                          "Um sabor",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )
                      )
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      NavigationHelper.pushNavigatorNoTransition(
                          context, HistoryPage()
                      );
                    },
                    child: Text(
                        "Histórico de Pedidos",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                    )
                ),
              ],
            ),
            ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                        MaterialPageRoute(
                          builder: (context) => MapScreen()
                        )
                      );
                    },
                    child: Text("Teste map")
                ),
          ],
        ),
      )
    );
  }
}
