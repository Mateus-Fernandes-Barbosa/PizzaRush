

class PizzaOrderNames {
  static const String id = 'id';
  static const String fkOrder = 'fk_user_order';
  static const String additionalRequests = 'additional_requests';
  static const String price = 'price';
}


class PizzaOrderGets {
  static int id(Map<String, dynamic> data) =>
      data[PizzaOrderNames.id] as int;

  static int fkOrder(Map<String, dynamic> data) =>
      data[PizzaOrderNames.fkOrder] as int;

  static String? additionalRequests(Map<String, dynamic> data) =>
      data[PizzaOrderNames.additionalRequests] as String?;

  static double price(Map<String, dynamic> data) =>
      (data[PizzaOrderNames.price] as num).toDouble();
}



