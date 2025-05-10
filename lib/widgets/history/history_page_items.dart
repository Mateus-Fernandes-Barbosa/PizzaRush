

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pizza_rush/database/wrappers_custom/order_full.dart';

import '../../historico_detalhes.dart';
import '../navigation_helper.dart';
import 'history_page_image_component.dart';

class HistoryWidget extends StatelessWidget {
  const HistoryWidget({required this.item, super.key});
  final OrderFullDetails item;

  Widget buildWidgetLayout(BuildContext context) {
    return ClipRRect (
      borderRadius: BorderRadius.circular(15.0),
      child: Material(
          color: Colors.white,
          child: InkWell(
              onTap: () => {
                // NavigationHelper.pushNavigatorNoTransition(
                //     context, HistoricoDetails(id: 0)
                // )
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HistoryItemImage(
                    image: null, // Add default image
                  ),
                  Expanded(
                      child: HistoryItemText(item: item)
                  )
                ],
              )
          )
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



  String getTimeDifference() {
    final Duration difference = DateTime.now().difference(item.order.deliveryTimeDateTime);


    if (difference.inDays == 0) {
      // Less than 1 day, show in hours, minutes, or seconds
      if (difference.inHours > 0) {
        return '${difference.inHours} horas atrás';

      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minutos atrás';
      } else {
        return '${difference.inSeconds} segundos atrás';
      }
    } else if (difference.inDays <= 7) {
      // Less than or equal to 7 days, show in days
      return '${difference.inDays} dias atrás';
    } else {
      // More than 7 days, show the date
      return DateFormat('dd-MM-yyyy').format(item.order.deliveryTimeDateTime);
    }
  }

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
          // Ignore location for now

          Text(
            'Endereço: ${item.address.line1}',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),


          Text(
            'Tempo de entrega: ${getTimeDifference()}',
            style: textTheme.bodyLarge, // Use caption style from TextTheme
          ),

          // TEMPORARILY REMOVED AS THERE IS NO SUITABLE DESCRIPTION
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              "Custo total: R\$${getTotalCost()}",
              style: textTheme.bodyMedium, // Use caption style from TextTheme
            ),
          ),
        ],
      ),
    );
  }
}









