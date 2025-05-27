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
class Bebida {
  final int id;
  late double preco;
  final String nome;
  final String imagem;

  Bebida({
    required this.id,
    required this.preco,
    required this.nome,
    required this.imagem,
  });
}

//This class is responsible for managing the prices of the flavors and drinks
// It contains a map for the id of the flavor or drink and the it's respective price
class Precos {
  late Map<int, double> idPreco;

  Precos() {
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
    if (isDiscount) {
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
        if (tamanho == "P") {
          return sabor.precoP; // Return the price of the flavor
        } else if (tamanho == "M") {
          return sabor.precoM; // Return the price of the flavor
        } else if (tamanho == "G") {
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
      double flavorPrice = getPrice(
        sabor,
        tamanho,
      ); // Get the price of the flavor
      if (flavorPrice > total) {
        total =
            flavorPrice; // Update the total price if the flavor price is greater
      }
    }
    for (int i = 0; i < selectedBeverages.length; i++) {
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
    pizza = Pizza(id: 0, observacao: "", tipoBorda: "Normal");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red[600]!, Colors.red[800]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar customizada
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${quantityFlavors} Sabores',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Monte sua pizza perfeita',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Conteúdo principal
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Seção de tamanho
                        _buildSectionCard(
                          title: "Escolha o tamanho da sua pizza",
                          icon: Icons.straighten,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: CustomDropdown<String>(
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
                          ),
                        ),

                        SizedBox(height: 20),

                        // Seção de borda
                        _buildSectionCard(
                          title: "Escolha o tipo de borda",
                          icon: Icons.radio_button_unchecked,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: CustomDropdown<String>(
                              items: ["Normal", "Cheddar", "Requeijão"],
                              initialItem: "Normal",
                              onChanged: (value) {
                                setState(() {
                                  if (value == null ||
                                      value.compareTo("Normal") == 0) {
                                    pizza.tipoBorda = "Normal";
                                  } else {
                                    pizza.tipoBorda = value;
                                  }
                                });
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Seção de sabores
                        _buildSectionCard(
                          title: "Total de Sabores - ${quantityFlavors}",
                          subtitle: totalOfFlavorsAvaliable,
                          icon: Icons.local_pizza,
                          child: Column(
                            children: List.generate(sabores.length, (index) {
                              final sabor = sabores[index];
                              final selecionado = selectedFlavors.contains(
                                sabor.id,
                              );

                              return Container(
                                margin: EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color:
                                      selecionado
                                          ? Colors.red[50]
                                          : Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color:
                                        selecionado
                                            ? Colors.red[300]!
                                            : Colors.grey[300]!,
                                    width: selecionado ? 2 : 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(12),
                                  leading: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 6,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        sabor.imagem,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    sabor.nome,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  subtitle: Text(
                                    "R\$ ${getPrice(sabor.id, tamanho).toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red[600],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  trailing: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          selecionado
                                              ? Colors.red[600]
                                              : Colors.transparent,
                                      border: Border.all(
                                        color:
                                            selecionado
                                                ? Colors.red[600]!
                                                : Colors.grey[400]!,
                                        width: 2,
                                      ),
                                    ),
                                    child:
                                        selecionado
                                            ? Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 18,
                                            )
                                            : null,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      if (selectedFlavors.length <
                                          quantityFlavors) {
                                        if (selecionado) {
                                          selectedFlavors.remove(sabor.id);
                                          totalOfFlavorsAvaliable =
                                              "Faltam escolher ${quantityFlavors - selectedFlavors.length} sabores";
                                        } else {
                                          selectedFlavors.add(sabor.id);
                                          totalOfFlavorsAvaliable =
                                              "Faltam escolher ${quantityFlavors - selectedFlavors.length} sabores";
                                        }
                                      } else {
                                        if (selecionado) {
                                          selectedFlavors.remove(sabor.id);
                                          totalOfFlavorsAvaliable =
                                              "Faltam escolher ${quantityFlavors - selectedFlavors.length} sabores";
                                        } else {
                                          showWarningDialog(
                                            context,
                                            quantityFlavors,
                                          );
                                        }
                                      }
                                    });
                                  },
                                ),
                              );
                            }),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Seção de bebidas
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue[600]!,
                                      Colors.blue[700]!,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.local_drink,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "Bebidas",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Spacer(),
                                    Switch(
                                      value: _addBeverages,
                                      onChanged: (value) {
                                        setState(() {
                                          _addBeverages = value;
                                          if (!_addBeverages) {
                                            selectedBeverages.clear();
                                          }
                                        });
                                      },
                                      activeColor: Colors.white,
                                      activeTrackColor: Colors.white
                                          .withOpacity(0.3),
                                      inactiveTrackColor: Colors.white
                                          .withOpacity(0.2),
                                    ),
                                  ],
                                ),
                              ),
                              if (_addBeverages)
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    children: List.generate(bebidas.length, (
                                      index,
                                    ) {
                                      final bebida = bebidas[index];
                                      final quantidade =
                                          selectedBeverages[bebida.id] ?? 0;

                                      return Container(
                                        margin: EdgeInsets.only(bottom: 12),
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color:
                                              quantidade > 0
                                                  ? Colors.blue[50]
                                                  : Colors.grey[50],
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color:
                                                quantidade > 0
                                                    ? Colors.blue[300]!
                                                    : Colors.grey[300]!,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 4,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.asset(
                                                  bebida.imagem,
                                                  //fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    bebida.nome,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Text(
                                                    "R\$ ${bebida.preco.toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                      color: Colors.blue[600],
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.red[600],
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.remove,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        if (selectedBeverages
                                                            .containsKey(
                                                              bebida.id,
                                                            )) {
                                                          selectedBeverages[bebida
                                                                  .id] =
                                                              selectedBeverages[bebida
                                                                  .id]! -
                                                              1;
                                                          if (selectedBeverages[bebida
                                                                  .id] ==
                                                              0) {
                                                            selectedBeverages
                                                                .remove(
                                                                  bebida.id,
                                                                );
                                                          }
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    border: Border.all(
                                                      color: Colors.grey[300]!,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "$quantidade",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.green[600],
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        if (selectedBeverages
                                                            .containsKey(
                                                              bebida.id,
                                                            )) {
                                                          selectedBeverages[bebida
                                                                  .id] =
                                                              selectedBeverages[bebida
                                                                  .id]! +
                                                              1;
                                                        } else {
                                                          selectedBeverages
                                                              .addEntries([
                                                                MapEntry(
                                                                  bebida.id,
                                                                  1,
                                                                ),
                                                              ]);
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        // Seção de observações
                        _buildSectionCard(
                          title: "Observações Sobre o Pedido",
                          subtitle: "(Opcional)",
                          icon: Icons.edit_note,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Ex: Sem cebola, massa bem assada...",
                                hintStyle: TextStyle(color: Colors.grey[500]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.all(16),
                              ),
                              maxLines: 3,
                              onChanged: (value) {
                                setState(() {
                                  pizza.observacao = value;
                                });
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 100), // Espaço para o botão fixo
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Valor total
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Text(
                    "R\$ ${getTotalPrice().toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[600],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            // Botão finalizar
            Expanded(
              child: Container(
                height: 56,
                child: ElevatedButton(
                  onPressed:
                      selectedFlavors.length == quantityFlavors
                          ? () {
                            List<PizzaSabor> pizzaSabores = [];
                            List<Map<String, dynamic>> orderItems = [];
                            List<Map<String, dynamic>> orderBeverages = [];

                            double total = getTotalPrice();

                            for (int i = 0; i < selectedBeverages.length; i++) {
                              int bebidaId = selectedBeverages.keys.elementAt(
                                i,
                              );
                              int quantidade = selectedBeverages[bebidaId]!;
                              double preco =
                                  bebidas
                                      .firstWhere((b) => b.id == bebidaId)
                                      .preco;
                              String nome =
                                  bebidas
                                      .firstWhere((b) => b.id == bebidaId)
                                      .nome;

                              orderBeverages.add({
                                'id': bebidaId,
                                'nome': nome,
                                'preco': preco,
                                'quantidade': quantidade,
                              });
                            }

                            for (int i = 0; i < selectedFlavors.length; i++) {
                              int saborId = selectedFlavors[i];
                              double preco = getPrice(saborId, tamanho);
                              String nome =
                                  sabores
                                      .firstWhere((s) => s.id == saborId)
                                      .nome;

                              pizzaSabores.add(
                                PizzaSabor(
                                  idPizza: pizza.id,
                                  sabor: saborId,
                                  tamanho: tamanho,
                                  preco: preco,
                                ),
                              );

                              orderItems.add({
                                'id': saborId,
                                'nome': nome,
                                'preco': preco,
                              });
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PaymentScreen(
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
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedFlavors.length == quantityFlavors
                            ? Colors.red[600]
                            : Colors.grey[400],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation:
                        selectedFlavors.length == quantityFlavors ? 8 : 0,
                    shadowColor: Colors.red[300],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.payment, size: 24),
                      SizedBox(width: 8),
                      Text(
                        "Finalizar Pedido",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    String? subtitle,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red[600]!, Colors.red[700]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}
