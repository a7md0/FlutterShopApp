import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;

import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: ListView.builder(
        itemCount: ordersProvider.orders.length,
        itemBuilder: (ctx, idx) => OrderItem(),
      ),
    );
  }
}
