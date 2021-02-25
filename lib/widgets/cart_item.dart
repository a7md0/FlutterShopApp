import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/cart.dart' as Cart;

class CartItem extends StatelessWidget {
  final Cart.CartItem cartItem;

  CartItem(this.cartItem);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart.Cart>(context, listen: false);

    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (dir) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove the item from your cart?'),
            actions: [
              FlatButton(
                child: Text('No'),
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
            ],
          ),
        );
      },
      onDismissed: (dir) => cart.removeItem(cartItem.productId),
      child: Card(
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
      ),
    );
  }
}
