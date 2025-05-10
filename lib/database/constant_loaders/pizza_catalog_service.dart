import 'package:pizza_rush/database/constants/default_pizza_border.dart';
import 'package:pizza_rush/database/names/address.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';
import '../constants/default_pizza_flavor.dart';
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
          PizzaFlavorNames.imageUrl: flavor.imageUrl
        },
        conflictAlgorithm: ConflictAlgorithm.ignore
      );
      print(flavor);
    }
    await batch.commit(noResult: true);
  }


  //----------------------------------------------
  // Price



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
          PizzaFlavorPriceNames.fkPizzaFlavor: flavor.fkPizzaFlavor
        },
        conflictAlgorithm: ConflictAlgorithm.ignore
      );
    }
    await batch.commit(noResult: true);
  }



  static Future<void> addPizzasBorders() async {
    final db = await DatabaseHelper.getDatabase();
    final batch = db.batch();
    for (var border in PizzaBorderCatalog.values) {
      batch.insert(
          SqlTable.pizza_border.name,
          {
            PizzaFlavorNames.id: border.id,
            PizzaFlavorNames.name: border.name,
            PizzaFlavorNames.description: border.description,
            PizzaFlavorNames.imageUrl: border.imageUrl
          },
          conflictAlgorithm: ConflictAlgorithm.ignore
      );
      print(border);
    }
    await batch.commit(noResult: true);
  }

}