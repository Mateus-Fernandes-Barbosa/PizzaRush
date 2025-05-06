import 'package:pizza_rush/database/names/address.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';
import '../constants/drink_dummy.dart';
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


  static Future<void> addDrink({
    required String name,
    required String brand,
    required String? description,
    required int fkNameLang,
    required Batch batch
  }) async {
    batch.insert(SqlTable.drink.name, {
      DrinkNames.name: name,
      DrinkNames.brand: brand,
      DrinkNames.description: description,
      DrinkNames.fkNameLang: fkNameLang
    });
  }

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
          DrinkNames.fkNameLang: await drink.langNameFk
        },
        conflictAlgorithm: ConflictAlgorithm.ignore
      );
      print(drink);
    }
    await batch.commit(noResult: true);
  }


  //----------------------------------------------
  // Price

  static Future<void> addDrinkPrice({
    required double price,
    required int startDate,
    required int? endDate,
    required int fkDrink,
    required Database db
  }) async {
    await db.insert(SqlTable.drink_price.name, {
      DrinkBasePriceNames.price: price,
      DrinkBasePriceNames.startDate: startDate,
      DrinkBasePriceNames.endDate: endDate,
      DrinkBasePriceNames.fkDrink: fkDrink
    });
  }

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