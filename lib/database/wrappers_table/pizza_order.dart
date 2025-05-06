import 'package:pizza_rush/database/names/pizza/order_pizza.dart';


class PizzaOrder {
  static List<String> columns = [
    PizzaOrderNames.id,
    PizzaOrderNames.price,
    PizzaOrderNames.additionalRequests,
  ];

  final Map<String, dynamic> _data;
  PizzaOrder(this._data);

  int get id => PizzaOrderGets.id(_data);
  double get price => PizzaOrderGets.price(_data);
  String? get additionalRequests => PizzaOrderGets.additionalRequests(_data);

  static List<PizzaOrder> fromQuery(List<Map<String, dynamic>> rows) =>
      rows.map((row) => PizzaOrder(row)).toList();
}

