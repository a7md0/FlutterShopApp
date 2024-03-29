import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/auth.dart';

import 'package:shop_app/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  Auth auth;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems => _items.where((item) => item.isFavorite).toList();

  Product findById(String id) {
    return _items.firstWhere((p) => p.id == id);
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    var url = 'https://flutter-shop-app-bb9c5-default-rtdb.firebaseio.com/products.json?auth=${auth.token}';
    if (filterByUser) {
      url += '&orderBy="creatorId"&equalTo="${auth.userId}"';
    }

    final favProductsUrl = 'https://flutter-shop-app-bb9c5-default-rtdb.firebaseio.com/userFavorites/${auth.userId}.json?auth=${auth.token}';

    try {
      final response = await http.get(url);
      final body = json.decode(response.body) as Map<String, dynamic>;
      if (body == null) {
        return;
      }

      final favoritesResponse = await http.get(favProductsUrl);
      final favoritesBody = json.decode(favoritesResponse.body);

      _items = body.entries
          .map((entry) => Product(
                id: entry.key,
                title: entry.value['title'],
                description: entry.value['description'],
                price: entry.value['price'],
                imageUrl: entry.value['imageUrl'],
                isFavorite: favoritesBody == null ? false : favoritesBody[entry.key] ?? false,
              ))
          .toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    var newProduct = product.copyWith(isFavorite: false);

    final url = 'https://flutter-shop-app-bb9c5-default-rtdb.firebaseio.com/products.json?auth=${auth.token}';
    final response = await http.post(
      url,
      body: json.encode({
        ...product.toJson(),
        'creatorId': auth.userId,
      }),
    );
    final body = json.decode(response.body);
    newProduct = newProduct.copyWith(id: body['name']);

    _items.add(newProduct);
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final idx = _items.indexWhere((p) => p.id == product.id);
    if (idx >= 0) {
      final url = 'https://flutter-shop-app-bb9c5-default-rtdb.firebaseio.com/products/${product.id}.json?auth=${auth.token}';
      await http.patch(url, body: json.encode(product.toJson()));
      _items[idx] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productId) async {
    final existingProductIndex = _items.indexWhere((p) => p.id == productId);
    var existingProduct = _items[existingProductIndex];

    _items.removeWhere((p) => p.id == productId);
    notifyListeners();

    final url = 'https://flutter-shop-app-bb9c5-default-rtdb.firebaseio.com/products/${productId}.json?auth=${auth.token}';

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();

      throw HttpException('Failed to delete product.');
    }

    existingProduct = null;
  }
}
