


class DrinkBasePriceNames {
  static const String id = 'id';
  static final String price = "price";
  static final String startDate = "start_date";
  static final String endDate = "end_date";
  static final String fkDrink = "fk_drink";
}


class DrinkBasePriceGets {
  static int id(Map<String, dynamic> data) =>
      data[DrinkBasePriceNames.id] as int;

  static double price(Map<String, dynamic> data) =>
      (data[DrinkBasePriceNames.price] as num).toDouble();

  static int startDateUnix(Map<String, dynamic> data) =>
      data[DrinkBasePriceNames.startDate] as int;

  static int? endDateUnix(Map<String, dynamic> data) =>
      data[DrinkBasePriceNames.endDate] as int?;

  static DateTime startDateAsDateTime(Map<String, dynamic> data) =>
      DateTime.fromMillisecondsSinceEpoch(data[DrinkBasePriceNames.startDate] as int);

  static DateTime? endDateAsDateTime(Map<String, dynamic> data) {
    int? unix = data[DrinkBasePriceNames.endDate] as int?;
    return unix == null ? null : DateTime.fromMillisecondsSinceEpoch(unix);
  }

  static int fkDrink(Map<String, dynamic> data) =>
      data[DrinkBasePriceNames.fkDrink] as int;
}