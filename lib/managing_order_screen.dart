import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'main_screen.dart';
import 'payment_screen.dart';

//Class to manage the order of flavors
// This class is responsible for displaying the flavors and allowing the user to select them
class Sabor {
  final int id;
  final String nome;
  final String imagem;
  final double precoP;
  final double precoM;
  final double precoG;

  Sabor({
    Key? key,
    required this.id,
    required this.nome,
    required this.imagem,
    required this.precoP,
    required this.precoM,
    required this.precoG,
  });

}

// This class is responsible for making the channel between the flavors and the pizza
// It contains the id of the pizza, the list of flavors, the size of the pizza and the price of the pizza
class PizzaSabor {
  final int idPizza;
  final int sabor;
  final String tamanho;
  final double preco;

  PizzaSabor({
    Key? key,
    required this.idPizza,
    required this.sabor,
    required this.tamanho,
    required this.preco,
  });
}

// This class is responsible for making the channel between the pizza and the order
// It contains the id of the pizza, the observation and the type of crust
class Pizza {
  final int id;
  String observacao;
  String tipoBorda;

  Pizza({
    Key? key,
    required this.id,
    required this.observacao,
    required this.tipoBorda,
  });
}

// This class is responsible for managing the drinks that are offered
// It contains the id of the drink, the name, and it's current price
class Bebida{
  final int id;
  late double preco;
  final String nome;
  final String imagem;

  Bebida({required this.id, required this.preco, required this.nome, required this.imagem});

}

//This class is responsible for managing the prices of the flavors and drinks
// It contains a map for the id of the flavor or drink and the it's respective price
class Precos{

  late Map<int, double> idPreco;

  Precos(){
    idPreco = {
      0: 40.0,
      1: 40.0,
      2: 40.0,
      3: 40.0,
      4: 40.0,
      5: 40.0,
      6: 13.50,
      7: 13.50,
      8: 13.50,
      9: 13.50,
      10: 7.50,
    };
  }

  setPrices(int id, double percentage, bool isDiscount) {
    double preco = idPreco[id]!;
    percentage /= 100;
    if(isDiscount){
      preco = idPreco[id]! - (idPreco[id]! * percentage);
    } else {
      preco = idPreco[id]! + (idPreco[id]! * percentage);
    }
    return preco;
  }
}

//--------------------------Screens---------------------------//
//StatelessWidget of the ManagingOrder screen
class ManagingOrder extends StatelessWidget {
  late int quantityFlavors;

  ManagingOrder({Key? key, required this.quantityFlavors});

  @override
  Widget build(BuildContext context) {
    return _ManagingOrder(quantityFlavors: quantityFlavors);
  }
}

//StatefulWidget of the ManagingOrder screen
class _ManagingOrder extends StatefulWidget {
  late int quantityFlavors;

  _ManagingOrder({required this.quantityFlavors});

  @override
  _ManagingOrderState createState() =>
      _ManagingOrderState(quantityFlavors: quantityFlavors);
}

//State of the ManagingOrder screen
class _ManagingOrderState extends State<_ManagingOrder> {

  //Variables Used
  late List<Sabor> sabores;
  late List<Bebida> bebidas;
  late String tamanho = "P"; // Default size of the pizza
  final int quantityFlavors;
  List<int> selectedFlavors = [];
  Map<int, int> selectedBeverages = {};
  late String totalOfFlavorsAvaliable;
  late Pizza pizza;
  final Precos precos = Precos();
  late bool _addBeverages = true;

  //Popup Warning Exceeded Quantity of Flavors
  // This function is responsible for displaying a warning message when the user tries to select more flavors than allowed
  void showWarningDialog(BuildContext context, int quantityFlavors) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Limite de Sabores Atingido"),
          content: Text(
            "Você já selecionou o número máximo de sabores. Favor selecionar apenas ",
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //Function to set the flavors
  // This function is responsible for setting the flavors in the list of flavors at the beginning of the screen
  void setFlavors() {
    //bool conectionSucceed = false;
    //if(conectionSucceed){
    //sabores = null; // Cria uma lista de sabores com os dados do banco de dados
    //} else {
    sabores = [
      Sabor(
        id: 0,
        nome: "Calabresa",
        imagem: 'lib/assets/images/calabresa.jpg',
        precoP: precos.setPrices(0, 33.33, true),
        precoM: precos.setPrices(0, 0, true),
        precoG: precos.setPrices(0, 33.33, false),
      ),
      Sabor(
        id: 1,
        nome: "Frango",
        imagem: 'lib/assets/images/frango.png',
        precoP: precos.setPrices(0, 33.33, true),
        precoM: precos.setPrices(0, 0, true),
        precoG: precos.setPrices(0, 33.33, false),
      ),
      Sabor(
        id: 2,
        nome: "Portuguesa",
        imagem: 'lib/assets/images/portuguesa.png',
        precoP: precos.setPrices(0, 33.33, true),
        precoM: precos.setPrices(0, 0, true),
        precoG: precos.setPrices(0, 33.33, false),
      ),
      Sabor(
        id: 3,
        nome: "Margherita",
        imagem: 'lib/assets/images/marguerita.png',
        precoP: precos.setPrices(0, 33.33, true),
        precoM: precos.setPrices(0, 0, true),
        precoG: precos.setPrices(0, 33.33, false),
      ),
      Sabor(
        id: 4,
        nome: "Quatro Queijos",
        imagem: 'lib/assets/images/quatroQueijos.png',
        precoP: precos.setPrices(0, 33.33, true),
        precoM: precos.setPrices(0, 0, true),
        precoG: precos.setPrices(0, 33.33, false),
      ),
      Sabor(
        id: 5,
        nome: "Pepperoni",
        imagem: 'lib/assets/images/pepperoni.png',
        precoP: precos.setPrices(0, 33.33, true),
        precoM: precos.setPrices(0, 0, true),
        precoG: precos.setPrices(0, 33.33, false),
      ),
    ];
    //}
  }

  //Function to set the drinks
  // This function is responsible for setting the drinks in the list of drinks at the beginning of the screen
  void setBeverages() {
    bebidas = [
      Bebida(
        id: 6,
        preco: precos.setPrices(6, 0, true),
        nome: "Coca-Cola",
        imagem: 'lib/assets/images/coca.png',
      ),
      Bebida(
        id: 7,
        preco: precos.setPrices(7, 0, true),
        nome: "Guaraná",
        imagem: 'lib/assets/images/guarana.png',
      ),
      Bebida(
        id: 8,
        preco: precos.setPrices(8, 0, true),
        nome: "Fanta",
        imagem: 'lib/assets/images/fanta.png',
      ),
      Bebida(
        id: 9,
        preco: precos.setPrices(9, 0, true),
        nome: "Sprite",
        imagem: 'lib/assets/images/sprite.png',
      ),
      Bebida(
        id: 10,
        preco: precos.setPrices(10, 0, true),
        nome: "Água",
        imagem: 'lib/assets/images/agua.png',
      ),
    ];
  }

  //Function to get the price of the flavor
  double getPrice(int id, String tamanho) {
    for (var sabor in sabores) {
      if (sabor.id == id) {
        if(tamanho == "P") {
          return sabor.precoP; // Return the price of the flavor
        } else if(tamanho == "M") {
          return sabor.precoM; // Return the price of the flavor
        } else if(tamanho == "G") {
          return sabor.precoG; // Return the price of the flavor
        }
      }
    }
    return 0.0; // Return 0.0 if the flavor is not found
  }

  //Function to get the total price of the order
  double getTotalPrice() {
    double total = 0.0;
    for (var sabor in selectedFlavors) {
      double flavorPrice = getPrice(sabor, tamanho); // Get the price of the flavor
      if(flavorPrice > total) {
        total = flavorPrice; // Update the total price if the flavor price is greater
      } 
    }
    for(int i = 0; i < selectedBeverages.length; i++) {
      int bebidaId = selectedBeverages.keys.elementAt(i);
      int quantidade = selectedBeverages[bebidaId]!;
      double preco = bebidas.firstWhere((b) => b.id == bebidaId).preco;
      total += preco * quantidade; // Add the price of the drink to the total
    }
    return total; // Return the total price of the pizza
  }

  _ManagingOrderState({required this.quantityFlavors}) {
    setFlavors();
    setBeverages();
    totalOfFlavorsAvaliable = "Faltam escolher ${quantityFlavors} sabores";
    pizza = Pizza(
      id: 0,
      observacao: "",
      tipoBorda: "Normal",
    );
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: 
        Text('${quantityFlavors} Sabores')
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Escolha o tamanho da sua pizza",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CustomDropdown<String>(
                  items: ["Pequeno", "Médio", "Grande"],
                  initialItem: "Pequeno",
                  onChanged: (value) {
                    setState(() {
                      if (value == "Pequeno") {
                        tamanho = "P";
                      } else if (value == "Médio") {
                        tamanho = "M";
                      } else if (value == "Grande") {
                        tamanho = "G";
                      }
                    });
                  },               
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: BorderSide.strokeAlignCenter),
                  child: Text(
                    "Escolha o tipo de borda",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CustomDropdown<String>(
                  items: ["Normal", "Cheddar", "Requeijão"],
                  initialItem: "Normal",
                  onChanged: (value) {
                    debugPrint("Value: ${value}");
                    setState(() {
                      if(value == null || value.compareTo("Normal") == 0){
                        pizza.tipoBorda = "Normal";
                      }
                      else{
                        pizza.tipoBorda = value;
                      }
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total de Sabores - ${quantityFlavors}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        totalOfFlavorsAvaliable,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap:
                      true, //Allows the ListView to take up only the space it needs
                  physics:
                      NeverScrollableScrollPhysics(), //Deactivates the internal scroll of the ListView
                  itemCount: sabores.length, // Structs the list with the number of flavors available
                  itemBuilder: (context, innerIndex) {
                    final sabor = sabores[innerIndex];
                    final selecionado = selectedFlavors.contains(sabor.id);
        
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(
                              width: 25,
                              height: 25,
                              sabor.imagem,
                              alignment: Alignment.center,

                          ),
                        ),
                        title: Text(
                          "${sabor.nome} - R\$ ${getPrice(sabor.id, tamanho).toStringAsFixed(2)}",
                        ),
                        trailing:
                            selecionado
                                ? Icon(Icons.check_circle, color: Colors.green)
                                : Icon(Icons.circle_outlined),
                        onTap: () {
                          setState(() {
                            if (selectedFlavors.length < quantityFlavors) {
                              if (selecionado) {
                                selectedFlavors.remove(sabor.id);
                                totalOfFlavorsAvaliable = "Faltam escolher ${quantityFlavors - selectedFlavors.length} sabores";
                              } else {
                                selectedFlavors.add(sabor.id);
                                totalOfFlavorsAvaliable = "Faltam escolher ${quantityFlavors - selectedFlavors.length} sabores";
                              }
                            } else {
                              if (selecionado) {
                                selectedFlavors.remove(sabor.id);
                                totalOfFlavorsAvaliable = "Faltam escolher ${quantityFlavors - selectedFlavors.length} sabores";
                              } else {
                                showWarningDialog(context, quantityFlavors);
                              }
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
                if(_addBeverages)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: BorderSide.strokeAlignCenter),
                    child: Text(
                      "Opções de Bebidas: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if(_addBeverages)
                  ListView.builder(
                    shrinkWrap:
                    true,
                    //Allows the ListView to take up only the space it needs
                    physics:
                    NeverScrollableScrollPhysics(),
                    //Deactivates the internal scroll of the ListView
                    itemCount: bebidas.length,
                    // Structs the list with the number of flavors available
                    itemBuilder: (context, innerIndex) {
                      final bebida = bebidas[innerIndex];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset(
                                bebida.imagem,
                            ),
                          ),
                          title: Text(
                            "${bebida.nome} - R\$ ${bebida.preco
                                .toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 12),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline,
                                    color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    if (selectedBeverages.containsKey(
                                        bebida.id) &&
                                        selectedBeverages[bebida.id]! > 0) {
                                      selectedBeverages[bebida.id] =
                                          selectedBeverages[bebida.id]! - 1;
                                      if (selectedBeverages[bebida.id] == 0) {
                                        selectedBeverages.remove(bebida.id);
                                      }
                                    }
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.add_circle_outline,
                                    color: Colors.green),
                                onPressed: () {
                                  setState(() {
                                    if (selectedBeverages.containsKey(
                                        bebida.id)) {
                                      selectedBeverages[bebida.id] =
                                          selectedBeverages[bebida.id]! + 1;
                                    } else {
                                      selectedBeverages.addEntries([
                                        MapEntry(bebida.id, 1)
                                      ]);
                                    }
                                  });
                                },
                              ),
                              Text(
                                "${selectedBeverages.containsKey(bebida.id)
                                    ? selectedBeverages[bebida.id]!
                                    : 0}",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                SwitchListTile(
                  activeColor: Colors.red,
                  title: Text("Desejo Bebidas"),
                  value: _addBeverages,
                  onChanged: (value) {
                    setState(() {
                      _addBeverages = value;
                      if(!_addBeverages){
                        selectedBeverages.clear();
                      }
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                  child: Column(
                    children: [
                      Text(
                        "Observações Sobre o Pedido (Opcional)",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "(Ex: Sem cebola)",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            pizza.observacao = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(

                onPressed: selectedFlavors.length == quantityFlavors 
                  ? () {
                      List<PizzaSabor> pizzaSabores = [];
                      List<Map<String, dynamic>> orderItems = [];
                      List<Map<String, dynamic>> orderBeverages = [];
                      
                      double total = getTotalPrice();

                      for(int i = 0; i < selectedBeverages.length; i++){
                        int bebidaId = selectedBeverages.keys.elementAt(i);
                        int quantidade = selectedBeverages[bebidaId]!;
                        double preco = bebidas.firstWhere((b) => b.id == bebidaId).preco;
                        String nome = bebidas.firstWhere((b) => b.id == bebidaId).nome;

                        orderBeverages.add({
                          'id': bebidaId,
                          'nome': nome,
                          'preco': preco,
                          'quantidade': quantidade,
                        });
                      }
                      
                      for(int i = 0; i < selectedFlavors.length; i++){
                        int saborId = selectedFlavors[i];
                        double preco = getPrice(saborId, tamanho);
                        String nome = sabores.firstWhere((s) => s.id == saborId).nome;
                        
                        pizzaSabores.add(PizzaSabor(
                          idPizza: pizza.id,
                          sabor: saborId,
                          tamanho: tamanho,
                          preco: preco,
                        ));
                        
                        orderItems.add({
                          'id': saborId,
                          'nome': nome,
                          'preco': preco,
                        });
                      }


                      
                      // Navegação para a tela de pagamento
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                            totalPrice: total,
                            orderItems: orderItems,
                            orderBeverages: orderBeverages,
                            observations: pizza.observacao,
                            crustType: pizza.tipoBorda,
                            size: tamanho,
                          ),
                        ),
                      );
                    }
                  : null, // Botão desabilitado se não tiver selecionado todos os sabores
                child: Text("Finalizar Pedido"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,//selectedFlavors.length == quantityFlavors ? Theme.of(context).primaryColor : Colors.grey,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
