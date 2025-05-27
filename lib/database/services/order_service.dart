import 'package:pizza_rush/database/constants/default_users.dart';
import 'package:pizza_rush/database/database_helper.dart';
import 'package:pizza_rush/database/constants/default_pizza_border.dart';
import 'package:pizza_rush/database/constants/default_pizza_flavor.dart';
import 'package:pizza_rush/database/constants/default_drinks.dart';

class OrderService {
  /// Saves a complete order to the database
  /// Returns the order ID if successful
  static Future<int> saveOrder({
    required String customerName,
    required String customerPhone,
    required String deliveryAddress,
    required double totalPrice,
    required List<Map<String, dynamic>> orderItems,
    required List<Map<String, dynamic>> orderBeverages,
    required String observations,
    required String crustType,
    required String size,
    required String paymentMethod,
  }) async {
    try {
      final db = await DatabaseHelper.getDatabase();

      // Start a transaction to ensure data consistency
      return await db.transaction((txn) async {
        // 1. Create or get address
        final addressId = await _createAddress(
          txn: txn,
          address: deliveryAddress,
        );

        // 2. Create user order
        final orderId = await _createUserOrder(
          txn: txn,
          addressId: addressId,
          customerName: customerName,
          customerPhone: customerPhone,
          observations: observations,
          totalPrice: totalPrice,
          paymentMethod: paymentMethod,
        );

        // 3. Save pizza data
        if (orderItems.isNotEmpty) {
          await _savePizzaOrder(
            txn: txn,
            orderId: orderId,
            orderItems: orderItems,
            observations: observations,
            crustType: crustType,
            size: size,
            totalPrice: totalPrice,
          );
        }

        // 4. Save beverages
        for (final beverage in orderBeverages) {
          await _saveBeverageOrder(
            txn: txn,
            orderId: orderId,
            beverage: beverage,
          );
        }

        return orderId;
      });
    } catch (e) {
      print('Error saving order: $e');
      rethrow;
    }
  }

  /// Creates an address and returns its ID
  static Future<int> _createAddress({
    required dynamic txn,
    required String address,
  }) async {
    return await txn.insert('address', {
      'line_1': address,
      'line_2': null,
      'neighborhood': null,
      'city': 'Belo Horizonte',
      'postal_code': null,
      'state': 'Minas Gerais',
      'country': 'Brasil',
    });
  }

  /// Creates a user order and returns its ID
  static Future<int> _createUserOrder({
    required dynamic txn,
    required int addressId,
    required String customerName,
    required String customerPhone,
    required String observations,
    required double totalPrice,
    required String paymentMethod,
  }) async {
    final now = DateTime.now();

    return await txn.insert('user_order', {
      'request_time': now.millisecondsSinceEpoch,
      'confirmation_time': now.millisecondsSinceEpoch,
      'delivery_time': now.add(Duration(minutes: 30)).millisecondsSinceEpoch,
      'fk_user': DefaultUsers.visitor.id,
      'fk_address': addressId,
      'primary_contact_phone': customerPhone,
      'primary_contact_name': customerName,
      'primary_contact_observations':
          observations.isNotEmpty ? observations : null,
      'total_amount': totalPrice,
      'payment_method': paymentMethod,
    });
  }

  /// Saves pizza order data
  static Future<void> _savePizzaOrder({
    required dynamic txn,
    required int orderId,
    required List<Map<String, dynamic>> orderItems,
    required String observations,
    required String crustType,
    required String size,
    required double totalPrice,
  }) async {
    // Calculate pizza price (highest flavor price)
    double pizzaPrice = 0.0;
    for (final item in orderItems) {
      if (item['preco'] > pizzaPrice) {
        pizzaPrice = item['preco'];
      }
    }

    // Create pizza order
    final pizzaOrderId = await txn.insert('order_pizza', {
      'fk_user_order': orderId,
      'additional_requests': observations.isNotEmpty ? observations : null,
      'price': pizzaPrice,
    });

    // Get border ID based on crust type
    int borderId = _getBorderId(crustType);

    // Add pizza flavors
    for (final item in orderItems) {
      // Get flavor price ID based on flavor and size
      int flavorPriceId = await _getFlavorPriceId(txn, item['id'], size);

      // Calculate percentage (equal distribution among flavors)
      int percentage = (100 / orderItems.length).round();

      await txn.insert('pizza_flavor_percentage', {
        'percentage': percentage,
        'fk_pizza_flavor_price': flavorPriceId,
        'fk_pizza_border': borderId,
        'fk_order_pizza': pizzaOrderId,
      });
    }
  }

  /// Saves beverage order data
  static Future<void> _saveBeverageOrder({
    required dynamic txn,
    required int orderId,
    required Map<String, dynamic> beverage,
  }) async {
    // Get drink price ID
    int drinkPriceId = await _getDrinkPriceId(txn, beverage['id']);

    // Save multiple quantities as separate entries
    for (int i = 0; i < beverage['quantidade']; i++) {
      await txn.insert('order_drink', {
        'fk_user_order': orderId,
        'fk_drink_price': drinkPriceId,
        'price': beverage['preco'],
      });
    }
  }

  /// Gets border ID based on crust type name
  static int _getBorderId(String crustType) {
    switch (crustType.toLowerCase()) {
      case 'cheddar':
        return PizzaBorderCatalog.cheddar.id;
      case 'requeijão':
      case 'queijo':
        return PizzaBorderCatalog.queijo.id;
      default:
        return PizzaBorderCatalog.normal.id;
    }
  }

  /// Gets flavor price ID based on flavor ID and size
  static Future<int> _getFlavorPriceId(
    dynamic txn,
    int flavorId,
    String size,
  ) async {
    // Direct mapping from managing_order_screen.dart IDs to PizzaFlavorPrices enum IDs
    // This ensures that the correct flavor is saved in the database
    switch (flavorId) {
      case 0: // Calabresa from managing_order_screen.dart
        return PizzaFlavorPrices.calabresaPreco1.id; // ID 0 in enum
      case 1: // Frango from managing_order_screen.dart
        return PizzaFlavorPrices.frangoPreco1.id; // ID 1 in enum
      case 2: // Portuguesa from managing_order_screen.dart
        return PizzaFlavorPrices.portuguesaPreco1.id; // ID 2 in enum
      case 3: // Margherita from managing_order_screen.dart
        return PizzaFlavorPrices.marguerittaPreco1.id; // ID 3 in enum
      case 4: // Quatro Queijos from managing_order_screen.dart
        return PizzaFlavorPrices.quatroQueijosPreco1.id; // ID 4 in enum
      case 5: // Pepperoni from managing_order_screen.dart
        return PizzaFlavorPrices.pepperoniPreco1.id; // ID 5 in enum
      default:
        // If somehow an invalid ID is passed, default to Calabresa
        print('WARNING: Invalid flavor ID $flavorId, defaulting to Calabresa');
        return PizzaFlavorPrices.calabresaPreco1.id;
    }
  }

  /// Gets drink price ID based on drink ID
  static Future<int> _getDrinkPriceId(dynamic txn, int drinkId) async {
    // For simplicity, we'll use the enum values directly
    // In a real app, you'd query the database
    switch (drinkId) {
      case 6: // Coca-Cola
        return DrinkPrices.cocaBottlePrice1.id;
        ;
      case 7: // Guaraná
        return DrinkPrices.spriteBottlePrice1.id;
      case 8: // Fanta (using Coca as fallback)
        return DrinkPrices.waterBottlePrice1.id;
      default:
        return DrinkPrices.cocaBottlePrice1.id;
    }
  }
}
