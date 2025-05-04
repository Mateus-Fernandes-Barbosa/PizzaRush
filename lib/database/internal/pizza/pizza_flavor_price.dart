import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../database_helper.dart';
import '../database_definitions.dart';



class PizzaFlavorPriceNames {
  static const String id = 'id';
  static final String priceSmall = "price_small";
  static final String priceMedium = "price_medium";
  static final String priceLarge = "price_large";
  static final String startDate = "start_date";
  static final String endDate = "end_date";
  static final String fkPizzaFlavor = "fk_pizza_flavor";
}


class PizzaFlavorPrice {
  final Map<String, dynamic> _data;
  PizzaFlavorPrice(this._data);

  int get id => _data[PizzaFlavorPriceNames.id] as int;
  double get priceSmall => _data[PizzaFlavorPriceNames.priceSmall] as double;
  double get priceMedium => _data[PizzaFlavorPriceNames.priceMedium] as double;  
  double get priceLarge => _data[PizzaFlavorPriceNames.priceLarge] as double;
  int get startDateUnix => _data[PizzaFlavorPriceNames.startDate] as int;
  int? get endDateUnix => _data[PizzaFlavorPriceNames.endDate] as int?;
  DateTime get startDateAsDateTime => DateTime.fromMillisecondsSinceEpoch(_data[PizzaFlavorPriceNames.startDate]);
  DateTime? get endDateAsDateTime {
    int? unix = _data[PizzaFlavorPriceNames.endDate] as int?;
    return unix == null ? null : DateTime.fromMillisecondsSinceEpoch(_data[PizzaFlavorPriceNames.endDate]);
  }
  int get fkDrink => _data[PizzaFlavorPriceNames.fkPizzaFlavor] as int;


  Map<String, dynamic> toMap() => _data;

  @override
  String toString() {
    return 'DrinkBasePrice(id: $id, priceM: $priceMedium, start: $startDateUnix, end: $endDateUnix, drinkId: $fkDrink)';
  }

  static List<PizzaFlavorPrice> fromQueryResult(List<Map<String, dynamic>> rows) {
    return rows.map((row) => PizzaFlavorPrice(row)).toList();
  }
}


