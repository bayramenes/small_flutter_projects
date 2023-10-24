import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../providers/product_provider.dart';
import './product_item.dart';

class GridOverView extends StatelessWidget {
  bool _showFavorites;
  GridOverView(this._showFavorites);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products =
        _showFavorites ? productsData.favorites : productsData.products;
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2),
        itemCount: products.length,
        itemBuilder: (BuildContext ctx, int index) =>
            ChangeNotifierProvider.value(
              value: products[index],
              child: ProductItem(),
            ));
  }
}
