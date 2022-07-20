import 'package:flutter/material.dart';
import '../providers/products.dart';
import '../widget/product_item.dart';
import 'package:provider/provider.dart';

class GridProduct extends StatelessWidget {
   GridProduct(this.showFavorite,{Key? key}) : super(key: key);
  bool showFavorite;

  @override
  Widget build(BuildContext context) {
    final productData=Provider.of<Products>(context);
    final product=showFavorite?productData.favorite: productData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          childAspectRatio: 3 / 2),
      itemBuilder: (ctx, index) =>ChangeNotifierProvider.value(value:product[index],
         child: const ProductItem(
          //    product[index].id,
              // product[index].title, product[index].imageUrl
              )
      ),
      itemCount: product.length,
    );
  }
}