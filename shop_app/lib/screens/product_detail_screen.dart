import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'product-detail';
  @override
  Widget build(BuildContext context) {
    final String productId =
        ModalRoute.of(context)!.settings.arguments as String;

    final productProvided = Provider.of<ProductsProvider>(context);

    final product = productProvided.getCorrespondingProduct(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
                height: 300,
                width: double.infinity,
                child: Image.network(product.imageUrl)),
            const SizedBox(
              height: 20,
            ),
            Text(
              '\$${product.price.toString()}',
              style: const TextStyle(fontSize: 25, color: Colors.grey),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              product.description,
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
