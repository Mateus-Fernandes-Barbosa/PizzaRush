import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pizza_rush/database/wrappers_table/address.dart';
import 'package:pizza_rush/database/wrappers_table/user_order.dart';

class UserOrderAddress {
  final UserOrder order;
  final SqlAddress address;
  UserOrderAddress(this.order, this.address);

  static Future<List<UserOrderAddress>> getAllFromUser(int userId) async {
    final orders = await UserOrder.getUserOrders(userId);
    List<UserOrderAddress> list = [];
    for (final order in orders) {
      SqlAddress address = await SqlAddress.getAddressesForUserOrder(order.id);
      list.add(UserOrderAddress(order, address));
    }
    return list;
  }
}