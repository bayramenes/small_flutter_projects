// packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/products_provider.dart';

import '../screens/product_add_or_edit_screen.dart';

class ProductSettingItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  ProductSettingItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(ProductAddEditScreen.routeName, arguments: id);
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
            ),
            IconButton(
              onPressed: () async {
                try {
                  await productsProvider.removeProduct(
                    productsProvider.getCorrespondingProduct(id),
                  );
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: theme.errorColor),
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
