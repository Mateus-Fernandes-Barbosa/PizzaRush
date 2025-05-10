import 'package:pizza_rush/database/names/drink/drink.dart';
import 'package:sqflite/sqlite_api.dart';


import 'package:pizza_rush/database/database_helper.dart';
import 'package:pizza_rush/database/database_definitions.dart';
import 'package:pizza_rush/database/names/drink/drink_price.dart';
import 'package:pizza_rush/database/names/drink/order_drink.dart';


class DrinkDescriptionNames {
  static String name = "name";
  static String brand = "brand";
  static String description = "description";
  static String basePrice = "base_price";
  static String price = "price";
  static String imageUrl = "imageUrl";
}

class DrinkDescriptionGets {
  static String name(Map<String, dynamic> data) =>
      data[DrinkDescriptionNames.name] as String;

  static String brand(Map<String, dynamic> data) =>
      data[DrinkDescriptionNames.brand] as String;

  static String description(Map<String, dynamic> data) =>
      data[DrinkDescriptionNames.description] as String;

  static double basePrice(Map<String, dynamic> data) =>
      (data[DrinkDescriptionNames.basePrice] as num).toDouble();

  static double price(Map<String, dynamic> data) =>
      (data[DrinkDescriptionNames.price] as num).toDouble();

  
  static String? imageUrl(Map<String, dynamic> data) =>
      data[DrinkDescriptionNames.imageUrl] as String?;

}


class DrinkDetails {
  final Map<String, dynamic> _data;
  DrinkDetails(this._data);

  String get name => DrinkDescriptionGets.name(_data);
  String get brand => DrinkDescriptionGets.brand(_data);
  String get description => DrinkDescriptionGets.description(_data);
  double get basePrice => DrinkDescriptionGets.basePrice(_data);
  double get price => DrinkDescriptionGets.price(_data);
  String? get imageUrl => DrinkDescriptionGets.imageUrl(_data);

  static List<DrinkDetails> fromQuery(List<Map<String, dynamic>> rows) =>
      rows.map((row) => DrinkDetails(row)).toList();


  static Future<List<DrinkDetails>> fromJoinQuery(Database db, int orderId) async {
    String selectQuery = '''
      od.${OrderDrinkNames.price} AS ${DrinkDescriptionNames.price},
      price.${DrinkBasePriceNames.price} AS ${DrinkDescriptionNames.basePrice},
      drink.${DrinkNames.description} AS ${DrinkDescriptionNames.description},
      drink.${DrinkNames.brand} AS ${DrinkDescriptionNames.brand},
      drink.${DrinkNames.name} AS ${DrinkDescriptionNames.name},
      drink.${DrinkNames.imageUrl} AS ${DrinkDescriptionNames.imageUrl}
    ''';

    String sql = '''
      SELECT $selectQuery
      FROM ${SqlTable.order_drink.name} AS od
      
      JOIN ${SqlTable.drink_price.name} AS price ON 
        price.${DrinkBasePriceNames.id} 
        = od.${OrderDrinkNames.fkDrinkInstance}
      
      JOIN ${SqlTable.drink.name} AS drink ON 
        price.${DrinkBasePriceNames.fkDrink} 
        = drink.${DrinkNames.id}
        
      WHERE od.${OrderDrinkNames.fkOrder} = ?
    ''';

    //debugPrint(sql);

    var map = await db.rawQuery(sql, [orderId]);
    return DrinkDetails.fromQuery(map);
  }


  static Future<List<DrinkDetails>> getAllDrinkDetails(int orderId) async {
    final db = await DatabaseHelper.getDatabase();
    return DrinkDetails.fromJoinQuery(db, orderId);
  }
}


