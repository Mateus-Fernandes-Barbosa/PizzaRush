


class OrderDrinkNames {
  static const String fkOrder = 'fk_user_order';
  static final String fkDrinkInstance = "fk_drink_price";
  static final String price = 'price';
}


class OrderDrinkGets {

  static int fkOrder(Map<String, dynamic> data) =>
      data[OrderDrinkNames.fkOrder] as int;

  static int fkDrinkInstance(Map<String, dynamic> data) =>
      data[OrderDrinkNames.fkDrinkInstance] as int;

  static double price(Map<String, dynamic> data) =>
      (data[OrderDrinkNames.price] as num).toDouble();
}


