import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];

  void addOrder(List<CartItem> products, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: products,
        createdAt: DateTime.now(),
      ),
    );
  }
}

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime createdAt;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.createdAt,
  });
}
