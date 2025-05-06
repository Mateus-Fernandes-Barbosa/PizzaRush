
class PizzaFlavorPercentageNames {
  static const String percentage = 'percentage';
  static const String fkFlavorPrice = 'fk_pizza_flavor_price';
  static const String fkOrderPizza = 'fk_order_pizza';


}

class PizzaFlavorPercentageGets {
  static int percentage(Map<String, dynamic> data) =>
      data[PizzaFlavorPercentageNames.percentage] as int;

  static int fkFlavorPrice(Map<String, dynamic> data) =>
      data[PizzaFlavorPercentageNames.fkFlavorPrice] as int;

  static int fkOrderPizza(Map<String, dynamic> data) =>
      data[PizzaFlavorPercentageNames.fkOrderPizza] as int;

  static String getString(Map<String, dynamic> data) {
    return 'UserOrder(percentage: $percentage, fk_pizza_flavor_price: $fkFlavorPrice, fk_order_pizza: $fkOrderPizza)';
  }
}

