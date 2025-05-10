

class PizzaFlavorPriceNames {
  static const String id = 'id';
  static final String priceSmall = "price_small";
  static final String priceMedium = "price_medium";
  static final String priceLarge = "price_large";
  static final String startDate = "start_date";
  static final String endDate = "end_date";
  static final String fkPizzaFlavor = "fk_pizza_flavor";
}


class PizzaFlavorPriceGets {
  static int id(Map<String, dynamic> data) =>
      data[PizzaFlavorPriceNames.id] as int;

  static double priceSmall(Map<String, dynamic> data) =>
      (data[PizzaFlavorPriceNames.priceSmall] as num).toDouble();

  static double priceMedium(Map<String, dynamic> data) =>
      (data[PizzaFlavorPriceNames.priceMedium] as num).toDouble();
  static double priceLarge(Map<String, dynamic> data) =>
      (data[PizzaFlavorPriceNames.priceLarge] as num).toDouble();

  static int startDate(Map<String, dynamic> data) =>
      data[PizzaFlavorPriceNames.startDate] as int;

  static int? endDateUnix(Map<String, dynamic> data) =>
      data[PizzaFlavorPriceNames.endDate] as int?;

  static DateTime startDateAsDateTime(Map<String, dynamic> data) =>
      DateTime.fromMillisecondsSinceEpoch(data[PizzaFlavorPriceNames.startDate] as int);

  static DateTime? endDateAsDateTime(Map<String, dynamic> data) {
    int? unix = data[PizzaFlavorPriceNames.endDate] as int?;
    return unix == null ? null : DateTime.fromMillisecondsSinceEpoch(unix);
  }

  static int fkDrink(Map<String, dynamic> data) =>
      data[PizzaFlavorPriceNames.fkPizzaFlavor] as int;
}

