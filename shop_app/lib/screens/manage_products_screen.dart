// packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// widgets

import '../widgets/app_drawer.dart';
import '../widgets/product_settings_item.dart';

// providers

import '../providers/products_provider.dart';

// screens

import './product_add_or_edit_screen.dart';

class ManageProductsScreen extends StatelessWidget {
  static const routeName = '/manage-products';

  Future<void> _refreshProdcuts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(ProductAddEditScreen.routeName);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: _refreshProdcuts(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return RefreshIndicator(
                onRefresh: () => _refreshProdcuts(context),
                child: Consumer<ProductsProvider>(
                  builder: (context, value, child) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: value.products.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            ProductSettingItem(
                                value.products[index].id,
                                value.products[index].title,
                                value.products[index].imageUrl),
                            Divider()
                          ],
                        );
                      },
                    ),
                  ),
                ),
              );
            }));
  }
}
