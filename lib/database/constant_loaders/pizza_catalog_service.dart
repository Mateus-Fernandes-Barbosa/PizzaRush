import 'package:pizza_rush/database/names/address.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';
import '../constants/pizza_flavor_dummy.dart';
import '../names/address.dart';
import '../database_definitions.dart';
import 'language_service.dart';
import '../names/pizza/pizza_flavor.dart';
import '../names/pizza/pizza_flavor_price.dart';

/* Description:
 *   Adds pizza flavor and respective current prices into database
 *   Supposed to be used to support server updates onto products
 *   For now it only loads static data
 *
 */
class StaticPizzaFlavorCatalog {


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
          PizzaFlavorNames.fkNameLang: await StaticLanguageLoader.getIdFromEnum(flavor.nameLang)
        },
        conflictAlgorithm: ConflictAlgorithm.ignore
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