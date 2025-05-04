import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../database_helper.dart';
import '../database_definitions.dart';



class DrinkBasePriceNames {
  static const String id = 'id';
  static final String price = "price";
  static final String startDate = "start_date";
  static final String endDate = "end_date";
  static final String fkDrink = "fk_drink";
}


class DrinkBasePrice {
  final Map<String, dynamic> _data;

  DrinkBasePrice(this._data);

  int get id => _data[DrinkBasePriceNames.id] as int;
  double get price => _data[DrinkBasePriceNames.price] as double;
  int get startDateUnix => _data[DrinkBasePriceNames.startDate] as int;
  int? get endDateUnix => _data[DrinkBasePriceNames.endDate] as int?;
  DateTime get startDateAsDateTime => DateTime.fromMillisecondsSinceEpoch(_data[DrinkBasePriceNames.startDate]);
  DateTime? get endDateAsDateTime {
    int? unix = _data[DrinkBasePriceNames.endDate] as int?;
    return unix == null ? null : DateTime.fromMillisecondsSinceEpoch(unix);
  }
  int get fkDrink => _data[DrinkBasePriceNames.fkDrink] as int;


  Map<String, dynamic> toMap() => _data;

  @override
  String toString() {
    return 'DrinkBasePrice(id: $id, price: $price, start: $startDateUnix, end: $endDateUnix, drinkId: $fkDrink)';
  }

  static List<DrinkBasePrice> fromQueryResult(List<Map<String, dynamic>> rows) {
    return rows.map((row) => DrinkBasePrice(row)).toList();
  }
}