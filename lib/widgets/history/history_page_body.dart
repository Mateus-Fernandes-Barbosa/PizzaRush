
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizza_rush/database/wrappers_custom/order_full.dart';

import '../../historico_detalhes.dart';
import '../../history.dart';
import '../navigation_helper.dart';
import 'history_page_items.dart';

class HistoryPageBody extends StatelessWidget {
  const HistoryPageBody({required this.list, super.key});
  final List<OrderFullDetails> list;

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
          ),
          textTheme: const TextTheme(
              displayLarge:
              TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
              displayMedium:
              TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
          child: HistoryList(list: list),
        ));
  }
}


class HistoryList extends StatelessWidget {
  const HistoryList({required this.list, super.key});

  final List<OrderFullDetails> list;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final historyItem = list[index]; // Get the current item from the list
          return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0, vertical: 4.0),

              child: Theme(
                data: Theme.of(context).copyWith(
                  textTheme: Theme.of(context).textTheme.copyWith(
                    titleMedium: const TextStyle(
                      color: Colors.black, // Set your desired color here
                      fontWeight: FontWeight.bold,
                    ),
                    bodyMedium: const TextStyle(
                      color: Colors.black, // Set body text color here
                    ),
                    bodySmall: const TextStyle(
                      color: Colors.grey, // Set caption text color here
                    ),
                    bodyLarge: const TextStyle(
                        color: Colors.black, // Set body text color here
                        fontSize: 16
                    ),
                  ),
                ),
                child: HistoryWidget(item: historyItem),
              )
          );
        }
    );
  }
}
