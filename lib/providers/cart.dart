import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/product.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount => _items.length;
  double get itemsTotalAmount {
    return _items.entries.fold(0, (total, cartItem) {
      return total + cartItem.value.price * cartItem.value.quantity;
    });
  }

  void addItem(Product product) {
    _items.update(
      product.id,
      (cartItem) => CartItem(
        id: cartItem.id,
        title: cartItem.title,
        quantity: cartItem.quantity + 1,
        price: cartItem.price,
        productId: cartItem.productId,
      ),
      ifAbsent: () => CartItem(
        id: DateTime.now().toString(),
        title: product.title,
        quantity: 1,
        price: product.price,
        productId: product.id,
      ),
    );

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }
}

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  final String productId;

  const CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.productId,
  });
}
