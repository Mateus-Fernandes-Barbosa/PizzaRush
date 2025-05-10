
import 'package:pizza_rush/database/database_helper.dart';
import 'package:pizza_rush/database/wrappers_join/pizza_details.dart';
import 'package:pizza_rush/database/wrappers_table/pizza_order.dart';



/* Description:
 *   Small response packet that couples details from pizza order to the details
 *   of their different flavorings
 */
class PizzaOrderDetailsEntry {
  final double price;
  // SMARTER AS A TABLE AS ITS RARELY USED
  final String? additionalAnnotations;
  final List<PizzaDescription> details;

  const PizzaOrderDetailsEntry(this.price, this.additionalAnnotations, this.details);

  static Future<List<PizzaOrderDetailsEntry>> getAllPizzaEntries(int orderId) async {
    final db = await DatabaseHelper.getDatabase();
    var pizzaOrders = await PizzaOrder.getAllPizzaOrders(orderId);
    
    List<PizzaOrderDetailsEntry> list = [];
    for (var pizzaOrder in pizzaOrders) {
      print(pizzaOrder.id);
      var details = await PizzaDescription.fromSinglePizzaOrder(pizzaOrder.id);
      list.add(PizzaOrderDetailsEntry(pizzaOrder.price, pizzaOrder.additionalRequests, details));
    }
    return list;
  }
}

