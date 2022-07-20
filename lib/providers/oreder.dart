import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../providers/cart_item_provider.dart';

class OrderedItem {
  final String id;
  final double amount;
  final DateTime date;
  final List<CartItems> products;

  OrderedItem({
    required this.id,
    required this.date,
    required this.amount,
    required this.products,
  });
}

class Order with ChangeNotifier {
  List<OrderedItem> _order = [];
  String? authToken;
  String? userId;

  getData(String authToken, String uId, List<OrderedItem> orders) {
    authToken = authToken;
    userId = uId;
    _order = orders;
    notifyListeners();
  }

  List<OrderedItem> get order {
    return [..._order];
  }

  Future<void> fetchAndSetOrder() async {
    final url = 'https://eslam-8e400-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final res = await http.get(Uri.parse(url));
    final List<OrderedItem> _loadedOrder = [];
    final extractData = json.decode(res.body) as Map<String, dynamic>;
    if(extractData==null){
      return;
    }
    extractData.forEach((ordId, orderData) {
      _loadedOrder.add(OrderedItem(
          id: ordId,
          date: DateTime.parse(orderData['date']),
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>).map((e) =>
              CartItems(id: e['id'], title: e['title'], quantity: e['quantity'], price:
                  e['price'])).toList()
      ));
    });
    _order=_loadedOrder.reversed.toList();
    notifyListeners();
// print(json.decode(res.body));
  }

  Future<void> addOrder(List<CartItems> cartProduct, double total) async {
    final url = 'https://eslam-8e400-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    final res = await http.post(Uri.parse(url),
        body: json.encode({
          'date': timeStamp.toIso8601String(),
          'amount': total,
          'products': cartProduct
              .map((e) =>
          {
            'id': e.id,
            'title': e.title,
            'quantity': e.quantity,
            'price': e.price
          })
              .toList()
        }));

    _order.insert(
        0,
        OrderedItem(
            id: jsonDecode(res.body)['name'],
            date: timeStamp,
            amount: total,
            products: cartProduct));
    notifyListeners();
  }
}
