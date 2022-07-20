import 'package:flutter/material.dart';
import 'package:marcket/providers/cart_item_provider.dart';
import 'package:marcket/screens/cart_screen.dart';
import 'package:marcket/widget/badge.dart';
import 'package:marcket/widget/drawer.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widget/grid_product.dart';

enum filters { favorite, all }

class ProductOverViewScreen extends StatefulWidget{

  const ProductOverViewScreen({ Key? key}):super(key: key);

  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}


class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var _showFavorite = false;
  //var _isInit=false;
  var _isLoading=false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading=true;
    });

    Future.delayed(Duration.zero).then((_){
      Provider.of<Products>(context,listen: false).fetchAndSetProducts().then((_) => {
      setState(() {
      _isLoading=false;
      })      });
    });
  }
//   @override
//   void didChangeDependencies(){
// if(_isInit){
//   Provider.of<Products>(context,listen: false).fetchAndSetProducts();
// }
// _isInit=false;
//     super.didChangeDependencies();
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My shop'),
        actions: [
          PopupMenuButton(
              onSelected: (filters selected) {
                setState(() {
                  if (selected == filters.favorite) {
                    _showFavorite = true;
                  } else {
                    _showFavorite = false;
                  }
                });
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      child: Text('Favorite only'),
                      value: filters.favorite,
                    ),
                    const PopupMenuItem(
                      child: Text('All'),
                      value: filters.all,
                    ),
                  ]),
          Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                    child: ch!,
                    value: cart.amount.toString(),
                  ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ))
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading?const Center(child: CircularProgressIndicator(),):GridProduct(_showFavorite),
    );
  }
}
