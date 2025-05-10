import 'package:pizza_rush/database/names/address.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';
import '../constants/default_drinks.dart';
import '../names/address.dart';
import '../database_definitions.dart';
import 'language_service.dart';
import '../names/drink/drink.dart';
import '../names/drink/drink_price.dart';

// Would be provided by cloud




/* Description:
 *   Adds drinks and respective current prices into database
 *   Supposed to be used to support server updates onto products
 *   For now it only loads static data
 *
 */
class StaticDrinkCatalog {


  static Future<void> addDrinksFromCatalog() async {
    final db = await DatabaseHelper.getDatabase();
    final batch = db.batch();
    for (var drink in DrinkCatalog.values) {
      batch.insert(
        SqlTable.drink.name,
        {
          DrinkNames.id: drink.id,
          DrinkNames.name: drink.name,
          DrinkNames.brand: drink.brand,
          DrinkNames.description: drink.description,
          DrinkNames.imageUrl: drink.imageUrl
        },
        conflictAlgorithm: ConflictAlgorithm.ignore
      );
      print(drink);
    }
    await batch.commit(noResult: true);
  }


  //----------------------------------------------
  // Price


  static Future<void> addDrinkPriceCatalog() async {
    final db = await DatabaseHelper.getDatabase();
    final batch = db.batch();
    for (var drink in DrinkPrices.values) {
      batch.insert(
        SqlTable.drink_price.name,
        {
          DrinkBasePriceNames.id: drink.id,
          DrinkBasePriceNames.price: drink.price,
          DrinkBasePriceNames.startDate: drink.startDate,
          DrinkBasePriceNames.endDate: drink.endDate,
          DrinkBasePriceNames.fkDrink: drink.fkDrink
        },
        conflictAlgorithm: ConflictAlgorithm.ignore
      );
    }
    await batch.commit(noResult: true);
  }

}