import 'package:flutter/material.dart';
import '../providers/products.dart';
import '../screens/edite_screen.dart';
import 'package:provider/provider.dart';

class UserProduct extends StatelessWidget {
  const UserProduct(this.id,this.title, this.imageUrl);
  final  String id;
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final scaffold=ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl,scale: 1),
      ),
      title: Text(title),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductsScreen.routeName,arguments:id );
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.secondary,
            ),
            IconButton(
              onPressed: () async{
                try{
                  await Provider.of<Products>(context,listen: false).delete(id);

                }catch(error){
                 scaffold.showSnackBar(const SnackBar(content: Text('deleted failed!!')));
                }

              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
