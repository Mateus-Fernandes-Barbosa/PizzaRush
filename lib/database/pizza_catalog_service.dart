import 'package:pizza_rush/database/internal/user.dart';
import 'package:sqflite/sqflite.dart';

import 'internal/address.dart';
import 'internal/database_definitions.dart';
import 'internal/database_helper.dart';
import 'internal/drink/drink.dart';
import 'internal/drink/drink_price.dart';
import 'internal/pizza/order_pizza.dart';
import 'internal/pizza/pizza_flavor.dart';
import 'internal/pizza/pizza_flavor_price.dart';
import 'language_service.dart';

// Would be provided by cloud
enum PizzaFlavorCatalog {
  margueritta(0, 'margueritta', null, Languages.ptBr),
  quatroQueijos(1, 'quatro queijos', null, Languages.ptBr),
  calabresa(2, 'Calabresa', null, Languages.ptBr);

  final int id;
  final String name;
  final String? description;
  final Languages nameLang;
  const PizzaFlavorCatalog(this.id, this.name, this.description, this.nameLang);
  
}

enum PizzaFlavorPrices {
  marguerittaPreco1(0, 7.00, 14.00, 21.00, '2024-05-26', null, PizzaFlavorCatalog.margueritta),
  quatroQueijosPreco1(1, 8.00, 15.00, 21.00, '2024-05-26', null, PizzaFlavorCatalog.quatroQueijos),
  calabresaPreco1(2, 6.50, 12.00, 17.5, '2024-05-26', null, PizzaFlavorCatalog.calabresa);

  final int id;
  final double priceSmall;
  final double priceMedium;
  final double priceLarge;
  final String startDateStr;
  final String? endDateStr;
  final PizzaFlavorCatalog fkPizzaFlavor;
  const PizzaFlavorPrices(this.id, this.priceSmall, this.priceMedium, this.priceLarge, this.startDateStr, this.endDateStr, this.fkPizzaFlavor);

  int get startDate => DateTime.parse(startDateStr).millisecondsSinceEpoch;
  int? get endDate => endDateStr != null ? DateTime.parse(endDateStr!).millisecondsSinceEpoch : null;
}




class PizzaFlavorCatalogService {


  static Future<void> addPizza({
    required int id,
    required String name,
    required String? description,
    required int fkNameLang,
  }) async {
    final db = await DatabaseHelper.getDatabase();
    await db.insert(SqlTable.pizza_flavor.name, {
      PizzaFlavorNames.id: id,
      PizzaFlavorNames.name: name,
      PizzaFlavorNames.description: description,
      PizzaFlavorNames.fkNameLang: fkNameLang
    });
  }

  static Future<void> addPizzasFromCatalog() async {
    final db = await DatabaseHelper.getDatabase();
    final batch = db.batch();
    for (var flavor in PizzaFlavorCatalog.values) {
      batch.insert(
        SqlTable.pizza_flavor.name,
        {
          PizzaFlavorNames.id: flavor.id,
          PizzaFlavorNames.name: flavor.name,
          PizzaFlavorNames.description: flavor.description,
          PizzaFlavorNames.fkNameLang: await DatabaseLanguage.getIdFromEnum(flavor.nameLang)
        },
        conflictAlgorithm: ConflictAlgorithm.replace
      );
      print(flavor);
    }
    await batch.commit(noResult: true);
  }


  //----------------------------------------------
  // Price

  static Future<void> add({
    required int id,
    required double priceSmall,
    required double priceMedium,
    required double priceLarge,
    required int startDate,
    required int? endDate,
    required int fkPizzaFlavor,
  }) async {
    final db = await DatabaseHelper.getDatabase();
    await db.insert(SqlTable.pizza_flavor_price.name, {
      PizzaFlavorPriceNames.id: id,
      PizzaFlavorPriceNames.priceSmall: priceSmall,
      PizzaFlavorPriceNames.priceMedium: priceMedium,
      PizzaFlavorPriceNames.priceLarge: priceLarge,
      PizzaFlavorPriceNames.startDate: startDate,
      PizzaFlavorPriceNames.endDate: endDate,
      PizzaFlavorPriceNames.fkPizzaFlavor: fkPizzaFlavor
    });
  }


  static Future<void> addPizzaPriceCatalog() async {
    final db = await DatabaseHelper.getDatabase();
    final batch = db.batch();
    for (var flavor in PizzaFlavorPrices.values) {
      batch.insert(
        SqlTable.pizza_flavor_price.name,
        {
          PizzaFlavorPriceNames.id: flavor.id,
          PizzaFlavorPriceNames.priceSmall: flavor.priceSmall,
          PizzaFlavorPriceNames.priceMedium: flavor.priceMedium,
          PizzaFlavorPriceNames.priceLarge: flavor.priceLarge,
          PizzaFlavorPriceNames.startDate: flavor.startDate,
          PizzaFlavorPriceNames.endDate: flavor.endDate,
          PizzaFlavorPriceNames.fkPizzaFlavor: flavor.fkPizzaFlavor.id
        },
        conflictAlgorithm: ConflictAlgorithm.ignore
      );
    }
    await batch.commit(noResult: true);
  }

}