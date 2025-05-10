
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryItemImage extends StatelessWidget {
  const HistoryItemImage({required this.image, super.key});

  final String? image;


  Widget getDefault() {
    return const Icon(
        Icons.monetization_on,
        size: 50
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
    return SizedBox (
      width: 150,
      height: 150,
      child: Center(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: SizedBox(
                  height: 100,
                  width: 100,
                  child: getImage()
              )
          )
      ),

    );
  }
}