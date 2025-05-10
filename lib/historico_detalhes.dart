
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoricoDetails extends StatefulWidget {
  final int id;

  HistoricoDetails({required this.id, super.key});

  @override
  _HistoricoDetailsState createState() => _HistoricoDetailsState();
}

class _HistoricoDetailsState extends State<HistoricoDetails> {

  @override
  void initState() {
    super.initState();
    // Initialize the data asynchronously
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: Future.value(0),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text("Loading...")),
            body: Center(child: CircularProgressIndicator()),  // Show loading indicator
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text("Error")),
            body: Center(child: Text('Error: ${snapshot.error}')),  // Show error message
          );
        } else if (snapshot.hasData) {
          // If the data is loaded successfully

          return Scaffold(
            appBar: AppBar(
              title: Text("Historico Details"),
              actions: [
                // You can use purchaseHistoryData here
                // Example: Appbar(onChanged: (String str) => {}, total: purchaseHistoryData.spendings)
              ],
            ),
            body: Body(),  // Pass the loaded data to the body
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: Text("No Data")),
            body: Center(child: Text("No data available")),  // In case no data is found
          );
        }
      },
    );
  }
}


// class HistoricoDetails extends StatelessWidget {
//   HistoricoDetails({required this.id, super.key}) : {
//   initializePurchaseHistory();
//   }
//   final int id;
//
//   late PurchaseHistory purchaseHistory;
//
//   Future<void> initializePurchaseHistory() async {
//     DatabaseHelper dbHelper = DatabaseHelper();
//     PurchaseProvider provider = PurchaseProvider(dbHelper);
//     final purchase = await provider.getByAutoIncrementId(id);
//
//     purchaseHistory = await PurchaseHistory.buildFromSql(dbHelper, purchase);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: Appbar(onChanged: (String str) => {}, total: productPurchaseHistory.spendings),
//       body: Body(data: productPurchaseHistory),
//     );
//   }
// }

/*
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historical Details'),
      ),
      body: FutureBuilder<ProductPurchaseHistory>(
        future: _productPurchaseHistoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the data, show a placeholder text or loading indicator
            return const Center(child: Text('Loading...'));
          } else if (snapshot.hasError) {

            // If an error occurred, show an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Once the data is available, build the actual widget
            final productPurchaseHistory = snapshot.data!;
            return Column(
              children: [
                AppBar(
                  title: Text('Total Spendings: ${productPurchaseHistory.spendings}'),
                ),
                Expanded(
                  child: Body(data: productPurchaseHistory),
                ),
              ],
            );
          } else {
            // If somehow no data was returned
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
 */

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  const Appbar({
    required this.onChanged,
    required this.total,
    super.key
  });

  final Function(String) onChanged;
  final double total;

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 80,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
            size: 40,
          ),
        ),

        title: Row (
            mainAxisAlignment: MainAxisAlignment.end,  // Align children to the right
            children: [

              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("Total:  ${total.toStringAsFixed(2)}")
              )
            ]
        )


    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ProductPurchasesViewer()
    );


  }

}

class ProductPurchasesViewer extends StatelessWidget {
  const ProductPurchasesViewer({ super.key});

  @override
  Widget build(BuildContext context) {
    List<int> list = [1,2,3];
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final productTotalSpending = 10.0;

          return Theme(
              data: Theme.of(context).copyWith(
                textTheme: Theme.of(context).textTheme.copyWith(
                  titleMedium: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  bodyLarge: const TextStyle(
                    color: Colors.black,
                  ),
                  bodyMedium: const TextStyle(
                    color: Colors.black,
                  ),
                  bodySmall: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              child: ProductTile(
                totalSpendings: productTotalSpending,
              )
          );
        }
    );
  }
}



class ProductTile extends StatefulWidget {
  const ProductTile({
    required this.totalSpendings,
    super.key
  });

  final double totalSpendings;


  @override
  // ignore: library_private_types_in_public_api
  _ProductTile createState() => _ProductTile();
}



class _ProductTile extends State<ProductTile> {
  bool _showExtraDetails = false;

  void _toggleExtraDetails() {
    setState(() {
      _showExtraDetails = !_showExtraDetails;
    });
  }

  Widget mainTile(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProductTileImage(
          image: "", // Add default image
        ),

        Expanded(
            child: ProductTileDescription(
              totalSpendings: widget.totalSpendings,
            )
        ),

        Padding(
          padding: const EdgeInsets.only(right: 24, left: 8, bottom: 50),
          child: Icon(
            _showExtraDetails ? Icons.expand_less : Icons.expand_more,
          ),
        )
      ],

    );
  }



  Widget buildWidgetLayout(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () => {
          _toggleExtraDetails()
        },

        child: Column(
          children: [

            mainTile(context),
            if (_showExtraDetails)
              InstanceTile(
                totalPrice: 20.0,
              )
          ],
        )      ,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
            right: 8.0, left: 8.0, top: 12.0, bottom: 4.0
        ),
        child: ClipRRect (
            borderRadius: BorderRadius.circular(15.0),
            child: buildWidgetLayout(context)
        )
    );
  }
}




class ProductTileImage extends StatelessWidget {
  const ProductTileImage({required this.image, super.key});

  final String? image;


  Widget getDefault() {
    return const Icon(
      Icons.image,
      size: 50,
      color: Colors.transparent,
    );
  }
  Widget? getImage() {
    if (image == "" || image == null) return getDefault();

    String validImage = image!;
    if (validImage.startsWith("http")) {

      return Image.network(
        validImage,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return getDefault();
        },
      );
    } else {
      return Image.asset(
        validImage,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return getDefault();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: SizedBox(
                height: 100,
                width: 100,
                child: getImage()
            )
        )
    );
  }
}




class InstanceTile extends StatelessWidget {
  const InstanceTile({
    required this.totalPrice,
    super.key
  });

  final double totalPrice;


  // The participant list rendering function
  Widget getInstanceList() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding( // Horizontal divider
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Divider(
                  color: Colors.black54,
                  thickness: 1,
                  height: 10,
                )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 5),
              child: getInstanceTile(),
            )

          ],
        )
      ],


    );
  }

  Widget getInstanceTile() {
    return SizedBox(
        height: 40,
        child:
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: contributionNamePair(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: contributionNamePair(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: contributionNamePair(),
            )
          ],
        )
    );
  }

  Widget contributionNamePair() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            color: const Color.fromARGB(255, 195,195,195),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 60),
                  child: Text("name"),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: VerticalDivider (
                    color: Colors.black54,  // Color of the divider
                    thickness: 1,           // Thickness of the divider
                    width: 10,              // Space around the divider
                  ),
                ),

                Text("R\$ 10.00"),
              ],
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
          getInstanceList()
        ]
    );
  }
}


class ProductTileDescription extends StatelessWidget {
  const ProductTileDescription({
    required this.totalSpendings,
    super.key
  });

  final double totalSpendings;


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "name",
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "R\$ 10",
                      style: textTheme.bodyMedium, // Use default body style from TextTheme
                    ),
                  ),
                ],
              ),
            ),

            Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: Column(
                  children: [
                    Text(
                        "Quantidade: X",
                        style: textTheme.bodyMedium
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Total: R\$ ${totalSpendings.toStringAsFixed(2)}",
                        style: textTheme.bodySmall, // Use default body style from TextTheme
                      ),
                    ),

                  ],
                )
            )

          ],
        )
    );
  }
}


