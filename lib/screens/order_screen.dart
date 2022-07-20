import 'package:flutter/material.dart';
import '../widget/drawer.dart';
import '../providers/oreder.dart'as show;
import '../widget/order_item.dart';
import 'package:provider/provider.dart';


class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);
  static const routeName='/order';


  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading=false;
  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading =true;
    });
    Future.delayed(Duration.zero).then((_)async{
       Provider.of<show.Order>(context,listen: false).fetchAndSetOrder().then((_) =>
       setState(() {
       _isLoading=false;
       }));

    });
  }
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<show.Order>(context,listen:false );
    return Scaffold(
      appBar: AppBar(title: const Text('your order'),),
      drawer: const AppDrawer(),
      body:_isLoading? const Center(child: CircularProgressIndicator(),):ListView.builder(itemBuilder: (ctx,index)=>OrderItem(data.order[index]),
        itemCount:data.order.length ,),
    );
  }
}
