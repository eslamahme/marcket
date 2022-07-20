import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_item_provider.dart';

class CartItem extends StatelessWidget {
  const CartItem(this.id, this.title, this.price, this.quantity,this.productId);

  final String id;
  final String productId;
  final String title;
  final double price;
  final double quantity;

  @override
  Widget build(BuildContext context) {
   final cart= Provider.of<Cart>(context,listen: false);
    return Dismissible(
        key: Key(id),
        background: Container(
          color: Theme.of(context).colorScheme.secondary,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
padding: const EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
        ),
        direction: DismissDirection.endToStart,
          onDismissed: (direction){
          cart.deleteItem(productId);
          },
        confirmDismiss: (direction){
          return showDialog(context: context, builder: (ctx)=> AlertDialog(
            title: const Text('Are you sure ?'),
            content: const Text('Do you want to remove the item from cart ?'),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(ctx).pop(false);
              }, child: const Text('No')),
              TextButton(onPressed: (){
                Navigator.of(ctx).pop(true);
              }, child: const Text('Yes')),

            ],
          ));
        },
          child:Card(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
              title: Text(title),
              subtitle: Text('Total ${price * quantity}'),
              trailing: Text(quantity.toStringAsFixed(0) + 'x'),
            ),
          ),
        )
    );
  }
}
