import 'package:pizza_rush/database/wrappers_custom/pizza_order_details.dart';
import 'package:pizza_rush/database/wrappers_join/drink_details.dart';
import 'package:pizza_rush/database/wrappers_table/address.dart';
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
    List<UserOrder> orders = await UserOrder.getUserOrders(userId);
    List<OrderFullDetails> fullDetails = [];

    for (UserOrder order in orders) {
      SqlAddress address = await SqlAddress.getAddressesForUserOrder(order.id);
      List<PizzaOrderDetailsEntry> pizzas =
          await PizzaOrderDetailsEntry.getAllPizzaEntries(order.id);
      List<DrinkDetails> drinks = await DrinkDetails.getAllDrinkDetails(
        order.id,
      );

      fullDetails.add(OrderFullDetails(order, address, pizzas, drinks));
    }

    return fullDetails;
  }
}
