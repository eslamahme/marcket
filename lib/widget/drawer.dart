import 'package:flutter/material.dart';
import 'package:marcket/screens/order_screen.dart';
import 'package:marcket/screens/user_product_screen.dart';
class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(title: const Text('HELLO FRIEND!!'), automaticallyImplyLeading: false,),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: (){
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('order'),
            onTap: (){
              Navigator.pushReplacementNamed(context, OrderScreen.routeName);
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Management'),
            onTap: (){
              Navigator.pushReplacementNamed(context, UserScreenProduct.routeName);
            },
          ),

        ],
      ),
    );
  }
}
