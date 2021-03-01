import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/auth.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(Auth auth) async {
    final oldStatus = isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();

    final url = 'https://flutter-shop-app-bb9c5-default-rtdb.firebaseio.com/userFavorites/${auth.userId}/${id}.json?auth=${auth.token}';
    try {
      final response = await http.put(
        url,
        body: json.encode(isFavorite),
      );

      if (response.statusCode >= 400) {
        throw HttpException('Failed to update product.');
      }
    } catch (e) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }

  Product copyWith({
    String id,
    String title,
    String description,
    double price,
    String imageUrl,
    bool isFavorite,
  }) =>
      Product(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        price: description ?? this.price,
        imageUrl: description ?? this.imageUrl,
        isFavorite: isFavorite ?? this.isFavorite,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'isFavorite': isFavorite,
      };
}
