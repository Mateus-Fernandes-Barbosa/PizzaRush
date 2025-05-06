import 'package:pizza_rush/database/names/drink/drink.dart';

class DrinkDescriptionNames {
  static String name = "name";
  static String brand = "brand";
  static String description = "description";
  static String basePrice = "base_price";
  static String price = "price";
}

class PizzaDescriptionGets {
  static String name(Map<String, dynamic> data) =>
      data[DrinkDescriptionNames.name] as String;

  static String brand(Map<String, dynamic> data) =>
      data[DrinkDescriptionNames.brand] as String;

  static String description(Map<String, dynamic> data) =>
      data[DrinkDescriptionNames.description] as String;

  static double basePrice(Map<String, dynamic> data) =>
      data[DrinkDescriptionNames.basePrice] as double;

  static double price(Map<String, dynamic> data) =>
      data[DrinkDescriptionNames.price] as double;


}


class DrinkDetails {
  final Map<String, dynamic> _data;
  DrinkDetails(this._data);

  String get name => PizzaDescriptionGets.name(_data);
  String get brand => PizzaDescriptionGets.brand(_data);
  String get description => PizzaDescriptionGets.description(_data);
  double get basePrice => PizzaDescriptionGets.basePrice(_data);
  double get price => PizzaDescriptionGets.price(_data);

  static List<DrinkDetails> fromQuery(List<Map<String, dynamic>> rows) =>
      rows.map((row) => DrinkDetails(row)).toList();
}


