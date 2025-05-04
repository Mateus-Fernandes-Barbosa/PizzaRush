import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'main_screen.dart';

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
  late List<Sabor> sabores;
  late String tamanho = "P"; // Default size of the pizza
  final int quantityFlavors;
  List<int> selectedFlavors = [];
  late String totalOfFlavorsAvaliable;
  late Pizza pizza;

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
        precoP: 10.0,
        precoM: 15.0,
        precoG: 20.0,
      ),
      Sabor(
        id: 1,
        nome: "Frango",
        imagem: 'lib/assets/images/calabresa.jpg',
        precoP: 10.0,
        precoM: 15.0,
        precoG: 20.0,
      ),
      Sabor(
        id: 2,
        nome: "Portuguesa",
        imagem: 'lib/assets/images/calabresa.jpg',
        precoP: 10.0,
        precoM: 15.0,
        precoG: 20.0,
      ),
      Sabor(
        id: 3,
        nome: "Margherita",
        imagem: 'lib/assets/images/calabresa.jpg',
        precoP: 10.0,
        precoM: 15.0,
        precoG: 20.0,
      ),
      Sabor(
        id: 4,
        nome: "Quatro Queijos",
        imagem: 'lib/assets/images/calabresa.jpg',
        precoP: 10.0,
        precoM: 15.0,
        precoG: 20.0,
      ),
      Sabor(
        id: 5,
        nome: "Vegetariana",
        imagem: 'lib/assets/images/calabresa.jpg',
        precoP: 10.0,
        precoM: 15.0,
        precoG: 20.0,
      ),
    ];
    //}
  }

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

  double getTotalPrice() {
    double total = 0.0;
    for (var sabor in selectedFlavors) {
      double flavorPrice = getPrice(sabor, tamanho); // Get the price of the flavor
      if(flavorPrice > total) {
        total = flavorPrice; // Update the total price if the flavor price is greater
      } 
    }
    return total; // Return the total price of the pizza
  }

  _ManagingOrderState({required this.quantityFlavors}) {
    setFlavors();
    totalOfFlavorsAvaliable = "Faltam escolher ${quantityFlavors} sabores";
    pizza = Pizza(
      id: 0,
      observacao: "",
      tipoBorda: "",
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
                          child: Image.asset(sabor.imagem, fit: BoxFit.cover),
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
                    setState(() {
                      if(value == null){
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
           ElevatedButton(
            onPressed: (){
              List<PizzaSabor> pizzaSabores = [];
              for(int i = 0; i < quantityFlavors; i++){
                pizzaSabores.add(PizzaSabor(
                  idPizza: pizza.id,
                  sabor: selectedFlavors[i],
                  tamanho: tamanho,
                  preco: getPrice(selectedFlavors[i], tamanho),
                ));
              }
              debugPrint("Pizza ID: ${pizza.id}, Observação: ${pizza.observacao}, Tipo de Borda: ${pizza.tipoBorda}, ");
              for(int i = 0; i < pizzaSabores.length; i++){
                PizzaSabor pizzaSabor = pizzaSabores[i];
                debugPrint("${i + 1}º Sabor: ${pizzaSabor.sabor}, Tamanho: ${pizzaSabor.tamanho}, Preço: R\$${pizzaSabor.preco}");
              }
            }, 
            child: Text("Confirmar Pedido"),
            ), 
          ],
        ),
      ),
    );
  }
}
