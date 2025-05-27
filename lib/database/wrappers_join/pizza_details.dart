import 'dart:core';

import 'package:pizza_rush/database/names/pizza/pizza_border.dart';

import 'package:pizza_rush/database/database_helper.dart';
import 'package:pizza_rush/database/database_definitions.dart';
import 'package:pizza_rush/database/names/pizza/pizza_flavor.dart';
import 'package:pizza_rush/database/names/pizza/pizza_flavor_percentage.dart';
import 'package:pizza_rush/database/names/pizza/pizza_flavor_price.dart';

class PizzaDescriptionNames {
  static String name = "name";
  static String description = "description";
  static String imageUrl = "imageUrl";

  static String pizzaBorderName = 'pizzaBorderName';
  static String pizzaBorderDescription = 'pizzaBorderDescription';
  static String pizzaImageUrl = 'pizzaImageUrl';

  static String percentage = "percentage";
  static String priceSmall = "priceSmall";
  static String priceMedium = "priceMedium";
  static String priceLarge = "priceLarge";
}

class PizzaDescriptionGets {
  static String name(Map<String, dynamic> data) =>
      data[PizzaDescriptionNames.name] as String;

  static String? description(Map<String, dynamic> data) =>
      data[PizzaDescriptionNames.description] as String?;

  static String? imageUrl(Map<String, dynamic> data) =>
      data[PizzaDescriptionNames.imageUrl] as String?;

  static String pizzaBorderName(Map<String, dynamic> data) =>
      data[PizzaDescriptionNames.pizzaBorderName] as String;

  static String? pizzaBorderDescription(Map<String, dynamic> data) =>
      data[PizzaDescriptionNames.pizzaBorderDescription] as String?;

  static String? pizzaImageUrl(Map<String, dynamic> data) =>
      data[PizzaDescriptionNames.pizzaImageUrl] as String?;

  static int percentage(Map<String, dynamic> data) =>
      data[PizzaDescriptionNames.percentage] as int;

  static double priceSmall(Map<String, dynamic> data) =>
      (data[PizzaDescriptionNames.priceSmall] as num).toDouble();

  static double priceMedium(Map<String, dynamic> data) =>
      (data[PizzaDescriptionNames.priceMedium] as num).toDouble();

  static double priceLarge(Map<String, dynamic> data) =>
      (data[PizzaDescriptionNames.priceLarge] as num).toDouble();
}

class PizzaDescription {
  final Map<String, dynamic> _data;
  PizzaDescription(this._data);

  String get name => PizzaDescriptionGets.name(_data);
  String? get description => PizzaDescriptionGets.description(_data);
  String? get imageUrl => PizzaDescriptionGets.imageUrl(_data);
  String get pizzaBorderName => PizzaDescriptionGets.pizzaBorderName(_data);
  String? get pizzaBorderDescription =>
      PizzaDescriptionGets.pizzaBorderDescription(_data);

  int get percentage => PizzaDescriptionGets.percentage(_data);
  double get priceSmall => PizzaDescriptionGets.priceSmall(_data);
  double get priceMedium => PizzaDescriptionGets.priceMedium(_data);
  double get priceLarge => PizzaDescriptionGets.priceLarge(_data);

  static List<PizzaDescription> fromMap(List<Map<String, dynamic>> rows) =>
      rows.map((row) => PizzaDescription(row)).toList();

  static Future<List<PizzaDescription>> fromSinglePizzaOrder(
    int pizzaOrder,
  ) async {
    final db = await DatabaseHelper.getDatabase();

    String selectQuery = '''
      flavor.${PizzaFlavorNames.name} AS ${PizzaDescriptionNames.name},
      flavor.${PizzaFlavorNames.description} AS ${PizzaDescriptionNames.description},
      flavor.${PizzaFlavorNames.imageUrl} AS ${PizzaDescriptionNames.imageUrl},
      
      border.${PizzaBorderNames.name} AS ${PizzaDescriptionNames.pizzaBorderName},
      border.${PizzaBorderNames.description} AS ${PizzaDescriptionNames.pizzaBorderDescription},
      border.${PizzaBorderNames.imageUrl} AS ${PizzaDescriptionNames.pizzaImageUrl},
      
      percentage.${PizzaFlavorPercentageNames.percentage} AS ${PizzaDescriptionNames.percentage},
      price.${PizzaFlavorPriceNames.priceSmall} AS ${PizzaDescriptionNames.priceSmall},
      price.${PizzaFlavorPriceNames.priceMedium} AS ${PizzaDescriptionNames.priceMedium},
      price.${PizzaFlavorPriceNames.priceLarge} AS ${PizzaDescriptionNames.priceLarge}

    ''';

    String sql = '''
      SELECT $selectQuery
      FROM ${SqlTable.pizza_flavor_percentage.name} AS percentage
      
      JOIN ${SqlTable.pizza_border.name} AS border ON 
        percentage.${PizzaFlavorPercentageNames.fkPizzaBorder} 
        = border.${PizzaBorderNames.id}
        
      JOIN ${SqlTable.pizza_flavor_price.name} AS price ON 
        percentage.${PizzaFlavorPercentageNames.fkFlavorPrice} 
        = price.${PizzaFlavorPriceNames.id}
        
      JOIN ${SqlTable.pizza_flavor.name} AS flavor ON 
        price.${PizzaFlavorPriceNames.fkPizzaFlavor} 
        = flavor.${PizzaFlavorNames.id}
        
      WHERE percentage.${PizzaFlavorPercentageNames.fkOrderPizza} = ?
    ''';

    var map = await db.rawQuery(sql, [pizzaOrder]);
    print(map);
    return PizzaDescription.fromMap(map);
  }
}
