import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';

import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((_) {
      Provider.of<Orders>(context, listen: false).fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: ordersProvider.orders.length,
        itemBuilder: (ctx, idx) => OrderItem(ordersProvider.orders[idx]),
      ),
    );
  }
}
