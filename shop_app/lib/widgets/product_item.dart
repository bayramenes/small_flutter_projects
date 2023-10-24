// dart utility
import 'dart:convert';

// packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/card_provider.dart';

// screens
import '../screens/product_detail_screen.dart';

// providers
import '../providers/product_provider.dart';

// widgets

import './badge.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);

    final theme = Theme.of(context);
    final productProvided = Provider.of<Product>(context, listen: false);
    final cardProvided = Provider.of<CardProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
              arguments: productProvided.id);
        },
        child: GridTile(
          child: Image.network(productProvided.imageUrl),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (context, value, _) => IconButton(
                icon: Icon(
                  value.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: theme.accentColor,
                ),
                onPressed: () async {
                  try {
                    await value.toggleFavoriteStatus(
                        authProvider.token, authProvider.userId);
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
              ),
            ),
            title: Text(
              productProvided.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: theme.accentColor,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                cardProvided.addCardItem(
                  productProvided.id,
                  productProvided.title,
                  productProvided.price,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Added item to shopping cart'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        cardProvided.removeSingleCardItem(productProvided.id);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
