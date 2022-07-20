import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  void _isFavorite(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token,String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://eslam-8e400-default-rtdb.firebaseio.com/product/$id.json?auth=$token';
    try {
      final res = await http.put(Uri.parse(url),
          body: json.encode(isFavorite));
      if (res.statusCode >= 400) {
        _isFavorite(oldStatus);
      }
    } catch (error) {
      _isFavorite(oldStatus);
      notifyListeners();
    }
  }
}
