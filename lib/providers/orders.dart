import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:shop_app/providers/cart.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];

  Future<void> addOrder(List<CartItem> products, double total) async {
    var order = OrderItem(
      id: null,
      amount: total,
      products: products,
      createdAt: DateTime.now(),
    );

    const url = 'https://flutter-shop-app-bb9c5-default-rtdb.firebaseio.com/orders.json';
    final response = await http.post(url, body: json.encode(order.toJson()));
    final body = json.decode(response.body);
    order = order.copyWith(id: body['name']);

    _orders.insert(0, order);
    notifyListeners();
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

  OrderItem copyWith({
    String id,
    double amount,
    List<CartItem> products,
    DateTime createdAt,
  }) =>
      OrderItem(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        products: products ?? this.products,
        createdAt: createdAt ?? this.createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'products': products.map((product) => product.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };
}
