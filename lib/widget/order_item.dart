import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/oreder.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  OrderItem(this.order);

  final ord.OrderedItem order;

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expand = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$ ${widget.order.amount}'),
            subtitle:
                Text(DateFormat('dd MM yyyy hh:mm').format(widget.order.date)),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expand = !_expand;
                });
              },
              icon: _expand
                  ? const Icon(Icons.expand_less)
                  : const Icon(Icons.expand_more),
            ),
          ),
          if (_expand)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 4),
              height: min(widget.order.products.length * 20.0 + 10, 100),
              child: ListView(
                children: widget.order.products
                    .map((e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('${e.quantity.toStringAsFixed(0)}X'+ '\$ ${e.price}',style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),)
                          ],
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
