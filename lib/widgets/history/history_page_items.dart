import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizza_rush/database/wrappers_custom/order_full.dart';

class HistoryWidget extends StatelessWidget {
  const HistoryWidget({required this.item, super.key});
  final OrderFullDetails item;

  Widget buildWidgetLayout(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap:
            () => {
              // NavigationHelper.pushNavigatorNoTransition(
              //     context, HistoricoDetails(id: item.order.id)
              // )
            },
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.red[400]!, Colors.red[600]!],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.local_pizza, color: Colors.white, size: 28),
              ),
              SizedBox(width: 16),
              Expanded(child: HistoryItemText(item: item)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildWidgetLayout(context);
  }
}

class HistoryItemText extends StatelessWidget {
  const HistoryItemText({required this.item, super.key});
  final OrderFullDetails item;

  // Should have had its own field on sql to account for discounts! big oof
  double getTotalCost() {
    double sum = 0;
    for (final pizza in item.pizza) {
      sum += pizza.price;
    }

    for (final drink in item.drinks) {
      sum += drink.price;
    }

    return sum;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order header with ID and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pedido #${item.order.id}',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Entregue',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 8),

          // Pizza details
          if (item.pizza.isNotEmpty) ...[
            Text(
              'Pizza(s):',
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            ...item.pizza.map((pizza) {
              List<String> flavorNames =
                  pizza.details.map((detail) => detail.name).toList();
              String borderType =
                  pizza.details.isNotEmpty
                      ? pizza.details.first.pizzaBorderName
                      : 'Normal';

              return Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                child: Text(
                  '• ${flavorNames.join(', ')} - Borda: $borderType - R\$ ${pizza.price.toStringAsFixed(2)}',
                  style: textTheme.bodyMedium,
                ),
              );
            }).toList(),
            SizedBox(height: 8),
          ],

          // Beverages details with quantities
          if (item.drinks.isNotEmpty) ...[
            Text(
              'Bebidas:',
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            // Group drinks by name and sum quantities
            ...(() {
              Map<String, List<dynamic>> groupedDrinks = {};
              for (var drink in item.drinks) {
                String key = '${drink.name} (${drink.brand})';
                if (!groupedDrinks.containsKey(key)) {
                  groupedDrinks[key] = [];
                }
                groupedDrinks[key]!.add(drink);
              }

              return groupedDrinks.entries.map((entry) {
                int quantity = entry.value.length;
                double totalPrice = entry.value.fold(
                  0.0,
                  (sum, drink) => sum + drink.price,
                );

                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                  child: Text(
                    '• ${quantity}x ${entry.key} - R\$ ${totalPrice.toStringAsFixed(2)}',
                    style: textTheme.bodyMedium,
                  ),
                );
              }).toList();
            })(),
            SizedBox(height: 8),
          ],

          // Total price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[600],
                ),
              ),
              Text(
                'R\$ ${getTotalCost().toStringAsFixed(2)}',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
