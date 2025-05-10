import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pizza_rush/database/constant_loaders/user_address.dart';
import 'package:pizza_rush/database/constants/default_users.dart';
import 'package:pizza_rush/database/wrappers_custom/order_full.dart';
import 'package:pizza_rush/widgets/history/history_page_appbar.dart';
import 'package:pizza_rush/widgets/history/history_page_body.dart';
import 'package:pizza_rush/widgets/navigation_helper.dart';
import 'package:sqflite/sqflite.dart';

import 'historico_detalhes.dart';





class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<OrderFullDetails>> _futureList; // Holds the async result

  @override
  void initState() {
    super.initState();
    _futureList = OrderFullDetails.getFullDetails(DefaultUsers.visitor.id);
  }

  void onSearchBarChanged(String input) {
    // Not implemented
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HistoryPageAppbar(onChanged: onSearchBarChanged),
      body: FutureBuilder<List<OrderFullDetails>>(
        future: _futureList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Loading spinner
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error message
          } else if (snapshot.hasData) {
            final list = snapshot.data!;
            return HistoryPageBody(list: list); // Render your list
          } else {
            return const Center(child: Text('No data available')); // Empty state
          }
        },
      ),
    );
  }

}


