

import 'package:pizza_rush/database/database_helper.dart';
import 'package:pizza_rush/database/wrappers_custom/pizza_order_details.dart';
import 'package:pizza_rush/database/wrappers_custom/user_address.dart';
import 'package:pizza_rush/database/wrappers_custom/user_order_address.dart';
import 'package:pizza_rush/database/wrappers_join/drink_details.dart';
import 'package:pizza_rush/database/wrappers_join/pizza_details.dart';
import 'package:pizza_rush/database/wrappers_table/address.dart';
import 'package:pizza_rush/database/wrappers_table/pizza_order.dart';
import 'package:pizza_rush/database/wrappers_table/user_order.dart';



/* Not optimized at all as most classes are still map based
 * TODO: STATICALLY DEFINE LATER
 */
class OrderFullDetails {
  final UserOrder order;
  final SqlAddress address;
  final List<PizzaOrderDetailsEntry> pizza;
  final List<DrinkDetails> drinks;

  const OrderFullDetails(this.order, this.address, this.pizza, this.drinks);

  static Future<List<OrderFullDetails>> getFullDetails(int userId) async {
    List<UserOrderAddress> userOrdersFull = await UserOrderAddress.getAllFromUser(userId);
    List<OrderFullDetails> fullDetails = [];

    for (final userOrderFull in userOrdersFull) {
      UserOrder userOrder = userOrderFull.order;
      final pizzaDetailsEntry = await PizzaOrderDetailsEntry.getAllPizzaEntries(userOrder.id);
      final drinkDetailsEntry = await DrinkDetails.getAllDrinkDetails(userOrder.id);
      final fullOrder = OrderFullDetails(userOrder, userOrderFull.address, pizzaDetailsEntry, drinkDetailsEntry);
      fullDetails.add(fullOrder);
    }
    return fullDetails;

  }
}

