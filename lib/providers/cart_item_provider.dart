import 'package:flutter/material.dart';

class CartItems {
  final String id;
  final String title;
  final double quantity;
  final double price;

  CartItems({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItems> _cartItem = {};

  Map<String, CartItems> get cartItem {
    return {..._cartItem};
  }

  int get amount {
    return _cartItem.length;
  }

  double get totalAmount {
    var total = 0.0;
    _cartItem.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, String title, double price) {
    if (_cartItem.containsKey(productId)) {
      _cartItem.update(
          productId,
          (existingProduct) => CartItems(
              id: existingProduct.id,
              title: existingProduct.title,
              quantity: existingProduct.quantity + 1,
              price: existingProduct.price));
    } else {
      _cartItem.putIfAbsent(
          productId,
          () => CartItems(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }

  void removeSelectItem(String productId) {
    if (!_cartItem.containsKey(productId)) {
      return;
    }
    if (_cartItem[productId]!.quantity > 1) {
      _cartItem.update(
          productId,
          (existingProduct) => CartItems(
              id: existingProduct.id,
              title: existingProduct.title,
              quantity: existingProduct.quantity - 1,
              price: existingProduct.price)
      );
    }else{
      _cartItem.remove(productId);
    }
    notifyListeners();
  }

  void deleteItem(String productId) {
    _cartItem.remove(productId);
    notifyListeners();
  }

  void clearItem() {
    _cartItem = {};
    notifyListeners();
  }
}
