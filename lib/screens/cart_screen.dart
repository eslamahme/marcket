import 'package:flutter/material.dart';
import '../widget/cart_item.dart';
import 'package:provider/provider.dart';

import '../providers/cart_item_provider.dart' show Cart;
import '../providers/oreder.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = 'cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _loading=false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(fontSize: 25)),
                  const Spacer(),
                  Chip(
                    label: Text(
                      ' \$' + cart.totalAmount.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  Flexible(
                    child: TextButton(
                      child: _loading? const CircularProgressIndicator() : Text(
                        'ORDERED NOW',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onPressed:( cart.totalAmount < 0 || _loading)
                          ? null
                          : ()async {
                        setState(() {
                          _loading=false;
                        });
                              await Provider.of<Order>(context, listen: false)
                                  .addOrder(cart.cartItem.values.toList(),
                                      cart.totalAmount);
                              cart.clearItem();
                            },
                    ),
                    flex: 2,
                  )
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, index) => CartItem(
              cart.cartItem.values.toList()[index].id,
              cart.cartItem.values.toList()[index].title,
              cart.cartItem.values.toList()[index].price,
              cart.cartItem.values.toList()[index].quantity,
              cart.cartItem.keys.toList()[index],
            ),
            itemCount: cart.cartItem.length,
          ))
        ],
      ),
    );
  }
}
