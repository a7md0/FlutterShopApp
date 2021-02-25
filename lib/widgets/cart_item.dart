import 'package:flutter/material.dart';

import 'package:shop_app/providers/cart.dart' as Cart;

class CartItem extends StatelessWidget {
  final Cart.CartItem cartItem;

  CartItem(this.cartItem);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: FittedBox(child: Text('\$${cartItem.price}')),
            ),
          ),
          title: Text(cartItem.title),
          subtitle: Text('Total: \$${cartItem.price * cartItem.quantity}'),
          trailing: Text('${cartItem.quantity} x'),
        ),
      ),
    );
  }
}
