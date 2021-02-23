import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';

class ProudctItem extends StatelessWidget {
  final Product product;

  ProudctItem(this.product);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(product.imageUrl),
    );
  }
}
