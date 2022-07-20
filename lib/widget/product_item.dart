import 'package:flutter/material.dart';
import 'package:marcket/providers/Auth.dart';
import 'package:marcket/providers/cart_item_provider.dart';
import 'package:marcket/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  // const ProductItem(this.id, this.title, this.imageUrl);
  //
  // final String id;
  // final String title;
  // final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth=Provider.of<Auth>(context,listen: false);
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                    arguments: product.id);
              },
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              )),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: Consumer<Product>(
                builder: (ctx, product, _) => IconButton(
                      icon: Icon(
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Theme.of(context).colorScheme.secondary),
                      onPressed: () {
                        product.toggleFavoriteStatus(auth.token!,auth.userId!);
                      },
                    )),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                cart.addItem(product.id!, product.title, product.price);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Added item to cart'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cart.removeSelectItem(product.id!);
                    },
                  ),
                ));
              },
            ),
          ),
        ));
  }
}
