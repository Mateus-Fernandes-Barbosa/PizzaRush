
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryPageAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HistoryPageAppbar({required this.onChanged, super.key});

  final Function(String) onChanged;

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

      // leading: Transform.translate(
      //   offset: const Offset(6, 0),  // Desloca o botão 10 pixels à direita
      //   child: IconButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     icon: const Icon(
      //       Icons.arrow_back_outlined,
      //       size: 40,
      //     ),
      //   ),
      // ),

      // title: Expanded(
      //   child: Row (
      //     children: [
      //       Expanded(
      //         child: SearchBar(
      //           padding: const WidgetStatePropertyAll<EdgeInsets>(
      //             EdgeInsets.symmetric(horizontal: 16.0),
      //           ),
      //           leading: const Icon(Icons.search),
      //           onChanged: onChanged,
      //         )
      //       ),
      //     ]
      //   )
      // ),

    );
  }
}
