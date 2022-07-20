import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class EditProductsScreen extends StatefulWidget {

  static const routeName = '/edit product';

  const EditProductsScreen({Key? key}) : super(key: key);

  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceFocus = FocusNode();
  final _descriptionFocusNod = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();
 final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _editProduct = Product(
      id: '', title: '', description: '', price: 0, imageUrl: '');
  var _initValues={
    'title':'',
    'description':'',
    'price':'',
    'imageUrl':''
  };
  var _isInit=true;
  bool _isLoading=false;
  @override
  void initState() {
    _imageFocusNode.addListener(_updateNode);
    super.initState();
  }
  @override
  void didChangeDependencies() {
    if(_isInit){
      final prodId=ModalRoute.of(context)!.settings.arguments.toString();
      _editProduct= Provider.of<Products>(context).findByID(prodId)!;
        _initValues={
          'title':_editProduct.title,
          'description':_editProduct.description,
          'price':_editProduct.price.toString(),
          // 'imageUrl':_editProduct.imageUrl
          'imageUrl':''
        };
        _imageUrlController.text=_editProduct.imageUrl;


    }
    _isInit=false;
    super.didChangeDependencies();

  }



  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateNode);
    _descriptionFocusNod.dispose();
    _priceFocus.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async{
    setState(() {
      _isLoading=true;
    });
    final isValidate = _formKey.currentState!.validate();
    if (!isValidate) {
      return;
    }
    _formKey.currentState!.save();

if(_editProduct.id!=null){
 await Provider.of<Products>(context,listen: false).updateProduct(
      _editProduct.id!, _editProduct);
 setState(() {
   _isLoading=false;
 });
 Navigator.of(context).pop();

}
else{
 try{await Provider.of<Products>(context,listen: false).addProduct(_editProduct);}catch (e){
   await  showDialog(context: context, builder: (ctx)=> AlertDialog(
     title: const Text('An error occurred!'),
     content:const Text('Some thing went wrong!') ,
     actions: [
       TextButton(onPressed: (){
         Navigator.of(ctx).pop();
       }, child: const Text('ok !'))
     ],
   ));
 }
 finally{
   setState(() {
     _isLoading=false;
   });
   Navigator.of(context).pop();
    }

  }




    // print(_editProduct.id);
    // print(_editProduct.title);
    // print(_editProduct.description);
    // print(_editProduct.price);
    // print(_editProduct.imageUrl);

  }

  void _updateNode() {
    if (!_imageFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
          !_imageUrlController.text.startsWith('https'))
          // ||(!_imageUrlController.text.endsWith('.png') &&
          // !_imageUrlController.text.endsWith('jpg') &&
          // !_imageUrlController.text.endsWith('jpeg'))
      ){
        return;
      }
      setState(() {});
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('edit product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body:_isLoading?const Center(child: CircularProgressIndicator(),) :Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocus);
                },
                onSaved: (value) {
                  _editProduct = Product(
                    title: value!,
                    description: _editProduct.description,
                    imageUrl: _editProduct.imageUrl,
                    price: _editProduct.price,
                    id:_editProduct.id,
                    isFavorite: _editProduct.isFavorite
                  );
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please enter the value';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: const InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocus,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNod);
                },
                onSaved: (value) {
                  _editProduct = Product(
                    title: _editProduct.title,
                    description: _editProduct.description,
                    imageUrl: _editProduct.imageUrl,
                    price: double.parse(value!),
                    id: _editProduct.id,
                    isFavorite: _editProduct.isFavorite
                  );
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return ' please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'please enter availed number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'please enter number greater than zero ';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: const InputDecoration(labelText: 'description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNod,
                onSaved: (value) {
                  _editProduct = Product(
                    title: _editProduct.title,
                    description: value!,
                    imageUrl: _editProduct.imageUrl,
                    price: _editProduct.price,
                    id: _editProduct.id,
                    isFavorite: _editProduct.isFavorite
                  );
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please enter a description.';
                  }
                  if (value.length < 10) {
                    return 'should be at least 10 characters';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: _imageUrlController.text.isEmpty
                        ? const Text('enter image url')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                              scale: 1,
                            ),
                          ),
                  ),
                  Expanded(
                      child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Image url'),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.url,
                    controller: _imageUrlController,
                    focusNode: _imageFocusNode,
                    onFieldSubmitted: (_) {
                      _saveForm();
                    },
                    onSaved: (value) {
                      _editProduct = Product(
                        title: _editProduct.title,
                        description: _editProduct.description,
                        imageUrl: value!,
                        price: _editProduct.price,
                        id: _editProduct.id,
                        isFavorite: _editProduct.isFavorite
                      );
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter a image url';
                      }
                      if (!value.startsWith('http') &&
                          !value.startsWith('https')) {
                        return ' enter availed  image url.';
                      }
                      // if (!value.endsWith('.png') &&
                      //     !value.endsWith('jpg') &&
                      //     !value.endsWith('jpeg')) {
                      //   return 'enter availed image';
                      // }
                      return null;
                    },
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
