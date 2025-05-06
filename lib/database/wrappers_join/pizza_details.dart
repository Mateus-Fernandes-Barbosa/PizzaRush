import 'dart:core';

import '../names/pizza/pizza_flavor.dart';
import '../names/pizza/pizza_flavor_percentage.dart';
import '../names/pizza/pizza_flavor_price.dart';

class PizzaDescriptionNames {
  static String name = "name";
  static String description = "description";
  static String percentage = "percentage";
  static String priceSmall = "priceSmall";
  static String priceMedium = "priceMedium";
  static String priceLarge = "priceLarge";
}

class PizzaDescriptionGets {
  static String name(Map<String, dynamic> data) =>
      data[PizzaDescriptionNames.name] as String;

  static String description(Map<String, dynamic> data) =>
      data[PizzaDescriptionNames.description] as String;

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
  String get description => PizzaDescriptionGets.description(_data);
  int get percentage => PizzaDescriptionGets.percentage(_data);
  double get priceSmall => PizzaDescriptionGets.priceSmall(_data);
  double get priceMedium => PizzaDescriptionGets.priceMedium(_data);
  double get priceLarge => PizzaDescriptionGets.priceLarge(_data);

  static List<PizzaDescription> fromQuery(List<Map<String, dynamic>> rows) =>
      rows.map((row) => PizzaDescription(row)).toList();
}




