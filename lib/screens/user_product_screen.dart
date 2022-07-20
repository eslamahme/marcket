import 'package:flutter/material.dart';
import 'package:marcket/screens/edite_screen.dart';
import 'package:marcket/widget/drawer.dart';
import '../providers/products.dart';
import '../widget/product_user.dart';
import 'package:provider/provider.dart';

class UserScreenProduct extends StatelessWidget {

  static const routeName = 'user screen';

  const UserScreenProduct({Key? key}) : super(key: key);
  Future<void> _refreshProducts(BuildContext context)async{
    await Provider.of<Products>(context,listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('your product'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductsScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: ()=>_refreshProducts(context),
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                  itemCount: userData.items.length,
                  itemBuilder: (_, index) => Column(children: [
                        UserProduct(
                            userData.items[index]!.id.toString(),
                            userData.items[index]!.title,
                            userData.items[index]!.imageUrl),
                        const Divider(),
                      ])))),
    );
  }
}
