import 'package:pizza_rush/database/internal/user.dart';
import 'package:sqflite/sqflite.dart';

import 'internal/address.dart';
import 'internal/database_definitions.dart';
import 'internal/database_helper.dart';
import 'internal/drink/drink.dart';
import 'internal/drink/drink_price.dart';
import 'language_service.dart';

// Would be provided by cloud
enum DrinkCatalog {
  cocaZeroCan(0, 'Coca Zero Lata 500ml', 'Coca-cola', null, Languages.ptBr),
  cocaCan(1, 'Coca Lata 500ml', 'Coca-cola', null, Languages.ptBr),
  cocaZeroGlassBottle(2, 'Coca Zero Bottle 550ml', 'Coca-cola', null, Languages.ptBr),
  guaranaGarrafaPet(3, 'Guarana garrafa 2L', 'Ambev', null, Languages.ptBr);

  final int id;
  final String name;
  final String brand;
  final String? description;
  final Languages langNameEnum;
  const DrinkCatalog(this.id, this.name, this.brand, this.description, this.langNameEnum);
  
  

  static List<String> acronyms() {
    return Languages.values.map((lang) => lang.acronym).toList();
  }

  Future<int> get langNameFk async => await DatabaseLanguage.getIdFromEnum(langNameEnum);
}

enum DrinkPrices {
  cocaZeroCanPrice1(0, 7.00, '2024-05-26', null, DrinkCatalog.cocaZeroCan),
  cocaCanPrice1(1, 7.00, '2024-05-26', null, DrinkCatalog.cocaCan),
  cocaZeroGlassBottlePrice1(2, 14.00, '2024-05-26', null, DrinkCatalog.cocaZeroGlassBottle),
  guarafaGarrafaPetPrice1(3, 20.00, '2024-05-26', null, DrinkCatalog.guaranaGarrafaPet);

  final int id;
  final double price;
  final String startDateStr;
  final String? endDateStr;
  final DrinkCatalog fkDrinkEnum;
  const DrinkPrices(this.id, this.price, this.startDateStr, this.endDateStr, this.fkDrinkEnum);

  int get startDate => DateTime.parse(startDateStr).millisecondsSinceEpoch;
  int? get endDate => endDateStr != null ? DateTime.parse(endDateStr!).millisecondsSinceEpoch : null;
  int get fkDrink => fkDrinkEnum.id;
}




class DrinkCatalogService {


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