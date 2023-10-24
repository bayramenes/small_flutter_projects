// packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// widgets
import '../widgets/grid_overview.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
// providers
import '../providers/card_provider.dart';
import '../providers/products_provider.dart';

// screens

import '../screens/card_screen.dart';

enum FavoritesOptions { ShowAll, ShowFavoritesOnly }

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/products-overview';

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  bool _showFavoriteOnly = false;
  @override
  Widget build(BuildContext context) {
    final card = Provider.of<CardProvider>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Anoos Shop'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (FavoritesOptions selectedValue) {
              setState(() {
                if (selectedValue == FavoritesOptions.ShowAll) {
                  _showFavoriteOnly = false;
                } else {
                  _showFavoriteOnly = true;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: FavoritesOptions.ShowAll,
                child: Row(
                  children: [
                    Icon(
                      _showFavoriteOnly
                          ? Icons.check_box_outline_blank
                          : Icons.check_box,
                      color: Theme.of(context).accentColor,
                    ),
                    const Text('Show All')
                  ],
                ),
              ),
              PopupMenuItem(
                value: FavoritesOptions.ShowFavoritesOnly,
                child: Row(
                  children: [
                    Icon(
                      _showFavoriteOnly
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: Theme.of(context).accentColor,
                    ),
                    const Text('Show Favorites')
                  ],
                ),
              ),
            ],
          ),
          Consumer<CardProvider>(
            builder: (_, value, child) =>
                Badge(child: child!, value: value.getLength.toString()),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CardScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : GridOverView(_showFavoriteOnly),
      ),
    );
  }
}
