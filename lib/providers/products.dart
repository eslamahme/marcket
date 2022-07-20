import 'dart:convert';

import 'package:flutter/material.dart';
import'package:http/http.dart' as http;
import 'package:marcket/models/http-exception.dart';
import '../providers/product.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product?> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
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
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var showFavoriteOnly = false;
   String? authToken;
   String? userId;
  getData(String authToken, String uId, List<Product?> products) {
    authToken = authToken;
    userId = uId;
    _items = products;
    notifyListeners();
  }
 // Products(this.authToken, this.userId, this._items);
  List<Product?> get items {
    // if(showFavoriteOnly){
    //   return _items.where((prodID) => prodID.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product?> get favorite {
    return _items.where((element) => element!.isFavorite).toList();
  }

  // void showFavoriteOnly(){
  //   _showFavoriteOnly=true;
  //   notifyListeners();
  // }
  // void showAll(){
  //   _showFavoriteOnly=false;
  //   notifyListeners();
  // }
  Product ? findByID(String id) {
    // return _items.where((element) => element.id==id);
    return _items.firstWhere((element) => element!.id == id, orElse: () =>
        Product(
            id: null,
            title: '',
            description: '',
            price: 0,
            imageUrl: ''));

    //  return _items.lastWhere((element) => element!.id==id,orElse: ()=>_items.elementAt((_items.lastIndexWhere((element) => element!.id==id,)))


  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = 'https://eslam-8e400-default-rtdb.firebaseio.com/product.json?auth=$authToken&$filterString';
    try {
      final res = await http.get(Uri.parse(url));
      print(json.decode(res.body));
        final extractData = json.decode(res.body) as Map<String, dynamic>;
      if (extractData == null) {
        return;
      }
      url = 'https://eslam-8e400-default-rtdb.firebaseio.com/product.json?auth=$authToken&';
      final favRes=await http.get(Uri.parse(url));
      final favData=json.decode(favRes.body);

      List<Product?> loadProducts = [];
      extractData.forEach((prodId, prodData) {
        loadProducts.add(Product(id: prodId,
            description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          isFavorite:favData==null?false: favData[prodId]??false,
            price: prodData['price'],
          title: prodData['title'],));
      });
      _items=loadProducts;
     // print(extractData);

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future <void> addProduct(Product prod) async {
    final url = 'https://eslam-8e400-default-rtdb.firebaseio.com/product.json?auth=$authToken';
    try {
      final res = await http.post(Uri.parse(url), body: jsonEncode({
        'title': prod.title,
        'description': prod.description,
        'price': prod.price,
        'imageUrl': prod.imageUrl,
        'creatorId':userId
      }));
      final newProduct = Product(
          title: prod.title,
          description: prod.description,
          price: prod.price,
          imageUrl: prod.imageUrl,
          id: jsonDecode(res.body)['name']);
      _items.add(newProduct);
      // _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future <void> updateProduct(String id, Product newProduct)async {
    final index = _items.indexWhere((prod) => prod!.id == id);
    if (index >= 0) {
      final url = 'https://eslam-8e400-default-rtdb.firebaseio.com/product.json?auth=$authToken';
      await http.patch(Uri.parse(url),body: json.encode({
        'title':newProduct.title,
        'description':newProduct.description,
        'price':newProduct.price,
        'imageUrl':newProduct.imageUrl
      }));
      _items[index] = newProduct;
      notifyListeners();
    } else {}
  }

 Future<void> delete(String id) async{
   final url = 'https://eslam-8e400-default-rtdb.firebaseio.com/product.json?auth=$authToken';

    final existingProductIndex=_items.indexWhere((element) => element!.id==id);
    var existingProduct=_items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final res= await http.delete(Uri.parse((url)));
    if(res.statusCode>=400){
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
       throw HttpException('Could not delete a product!!');
    }
      existingProduct=null;

  }
}
