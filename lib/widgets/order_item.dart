import 'package:flutter/material.dart';

import 'package:shop_app/providers/orders.dart' as Orders;

class OrderItem extends StatelessWidget {
  final Orders.OrderItem orderItem;

  OrderItem(this.orderItem);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${orderItem.amount}'),
          )
        ],
      ),
    );
  }
}
