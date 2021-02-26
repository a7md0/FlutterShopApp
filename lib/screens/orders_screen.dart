import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';

import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    print('OrdersScreen build');

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred'),
            );
          }

          return Consumer<Orders>(
            builder: (ctx, ordersProvider, child) => ListView.builder(
              itemCount: ordersProvider.orders.length,
              itemBuilder: (ctx, idx) => OrderItem(ordersProvider.orders[idx]),
            ),
          );
        },
      ),
    );
  }
}
