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
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: HistoryList(list: list),
    );
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
        final item = list[index];
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: HistoryWidget(item: item),
        );
      },
    );
  }
}
