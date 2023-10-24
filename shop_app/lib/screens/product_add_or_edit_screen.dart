// packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/product_provider.dart';
import '../providers/products_provider.dart';

class ProductAddEditScreen extends StatefulWidget {
  static const routeName = '/product-add-edit';

  @override
  State<ProductAddEditScreen> createState() => _ProductAddEditScreenState();
}

class _ProductAddEditScreenState extends State<ProductAddEditScreen> {
  // to detect if the adding or editing request is being progressed and when finished to not show the spinner

  bool isLoading = false;
  // to detect whether this is a new product or an old one

  bool isNew = true;
  // form global key
  final _formKey = GlobalKey<FormState>();
  // focus nodes

  final priceFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final imageUrlFocusNode = FocusNode();

  // text controller for the image url so we can update the preview

  final TextEditingController imageUrlController = TextEditingController();
  // to be able to initialize a list if not initialized in the did change dependencies
  bool _isInit = false;

  // the new product that will be submitted and added or updated
  Product _newProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');

  // the values that are going to be displayed by the form
  Map<String, String> _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  // update the image preview when the focus changes out of the image url field

  void _updateImage() {
    if (!imageUrlFocusNode.hasFocus) {
      setState(() {
        _initValues['imageUrl'] = imageUrlController.text;
      });
    }
  }

  // save data when the user submit and add it to the products list

  void _saveForm() async {
    bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState!.save();
      if (isNew) {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_newProduct);
        setState(() {
          isLoading = false;
        });
      } else {
        final productId = ModalRoute.of(context)?.settings.arguments as String;
        await Provider.of<ProductsProvider>(context, listen: false)
            .replaceProduct(productId, _newProduct);
        setState(() {
          isLoading = false;
        });
      }
      Navigator.of(context).pop();
    }
  }

  // to get the data arguments from the push navigator and initailize the displayed data accordingly

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments;

      if (productId != null) {
        _newProduct = Provider.of<ProductsProvider>(context, listen: false)
            .getCorrespondingProduct(productId as String);

        _initValues = {
          'title': _newProduct.title,
          'description': _newProduct.description,
          'price': _newProduct.price.toString(),
        };
        imageUrlController.text = _newProduct.imageUrl;
        isNew = false;
      }
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  // add a listener to the imageurl so when the focus state changes it triggers that function

  @override
  void initState() {
    super.initState();
    imageUrlFocusNode.addListener(_updateImage);
  }

  // dispose every listener and node

  @override
  void dispose() {
    imageUrlFocusNode.removeListener(_updateImage);
    priceFocusNode.dispose();
    descriptionFocusNode.dispose();
    imageUrlFocusNode.dispose();
    imageUrlController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () => _saveForm(), icon: Icon(Icons.save))
        ],
        title: Text(
          _initValues['title']!.isEmpty ? 'Add Product' : _initValues['title']!,
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).accentColor,
            ))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (titleToValidate) {
                          if (titleToValidate!.isEmpty) {
                            return 'Please Provide a title';
                          }
                          return null;
                        },
                        onSaved: (newTitle) {
                          _newProduct.changeTitle(newTitle as String);
                        },
                        decoration: const InputDecoration(labelText: 'title'),
                        initialValue: _initValues['title'],
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(priceFocusNode),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (priceToValidate) {
                          if (priceToValidate!.isEmpty ||
                              double.tryParse(priceToValidate) == null) {
                            return 'Please Provide a price with a numeric value';
                          }
                          return null;
                        },
                        onSaved: (newPrice) {
                          _newProduct
                              .changePrice(double.parse(newPrice as String));
                        },
                        decoration: const InputDecoration(labelText: 'price'),
                        initialValue: _initValues['price'],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: priceFocusNode,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(descriptionFocusNode),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (descriptionToValidate) {
                          if (descriptionToValidate!.isEmpty ||
                              descriptionToValidate.length < 20) {
                            return 'Please Provide a description (at least 20)';
                          }
                          return null;
                        },
                        onSaved: (newDescription) {
                          _newProduct
                              .changeDescription(newDescription as String);
                        },
                        decoration:
                            const InputDecoration(labelText: 'description'),
                        initialValue: _initValues['description'],
                        maxLines: 3,
                        focusNode: descriptionFocusNode,
                        textInputAction: TextInputAction.newline,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: imageUrlController.text.isNotEmpty
                              ? Image.network(imageUrlController.text)
                              : const Text(
                                  'Enter a url to preview',
                                  textAlign: TextAlign.center,
                                ),
                          margin: const EdgeInsets.all(10),
                        ),
                        Expanded(
                          child: TextFormField(
                            validator: (urlToValidate) {
                              if (!urlToValidate!.startsWith('http://') &&
                                      !urlToValidate.startsWith('https://') ||
                                  (!urlToValidate.endsWith('.jpg') &&
                                      !urlToValidate.endsWith('.png') &&
                                      !urlToValidate.endsWith('.jpeg'))) {
                                return 'Please Provide a valid url';
                              }
                              return null;
                            },
                            onSaved: (newImageUrl) {
                              _newProduct.changeImageUrl(newImageUrl as String);
                            },
                            decoration:
                                const InputDecoration(labelText: 'image url'),
                            controller: imageUrlController,
                            focusNode: imageUrlFocusNode,
                            onFieldSubmitted: (value) => _saveForm(),
                          ),
                        ),
                      ])
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
