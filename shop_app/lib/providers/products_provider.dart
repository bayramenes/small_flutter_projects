// dart utility

import 'dart:convert';

// packages

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// models
import '../models/http_exception.dart';

// providers
import './product_provider.dart';
import './auth_provider.dart';

class ProductsProvider with ChangeNotifier {
  final String? authToken;
  final String? userId;

  // the url that will be used to fetch and write data to the data base

  List<Product> _products = [];

  ProductsProvider(this.authToken, this.userId, this._products);

  // return the products list in a new list so that we can trigger notify listeners properly

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favorites {
    return products
        .where(
          (productItem) => productItem.isFavorite == true,
        )
        .toList();
  }

  Product getCorrespondingProduct(String id) {
    return products.firstWhere((productItem) => productItem.id == id);
  }

  // remove a product from the list

  Future<void> removeProduct(Product productToRemove) async {
    final url = Uri.parse(
        'https://flutter-shop-app-fa37c-default-rtdb.firebaseio.com/products/${productToRemove.id}.json?auth=$authToken');

    final productIndex = _products.indexWhere(
        (productToCheck) => productToCheck.id == productToRemove.id);
    Product? existingProduct = _products[productIndex];
    _products.removeAt(productIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _products.insert(productIndex, existingProduct);
      notifyListeners();
      throw HttpException("Deleting Product Failed!!");
    }
    existingProduct = null;
  }

  Future<void> addProduct(Product newProduct) async {
    final url = Uri.parse(
        'https://flutter-shop-app-fa37c-default-rtdb.firebaseio.com/products.json?auth=$authToken');

    final response = await http.post(
      url,
      body: json.encode(
        newProduct.toMap(userId!),
      ),
    );

    newProduct.changeId(json.decode(response.body)['name']);

    _products.add(newProduct);

    notifyListeners();
  }

  Future<void> replaceProduct(String oldProductId, Product newProduct) async {
    final url = Uri.parse(
        'https://flutter-shop-app-fa37c-default-rtdb.firebaseio.com/products/$oldProductId.json?auth=$authToken');

    try {
      await http.patch(
        url,
        body: json.encode(
          newProduct.toMap(userId!),
        ),
      );
      Product productToReplace =
          _products.firstWhere((element) => element.id == oldProductId);
      productToReplace = newProduct;
    } catch (error) {
      rethrow;
    }

    notifyListeners();
  }

  // fetch data from the server

  Future<void> fetchAndSetProducts([bool isUserSpecific = false]) async {
    String filterSegment =
        isUserSpecific ? '&orderBy="userId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://flutter-shop-app-fa37c-default-rtdb.firebaseio.com/products.json?auth=$authToken$filterSegment');

    try {
      // fetch data fromt the server
      final response = await http.get(url);

      Map<String, dynamic>? productsList = json.decode(response.body);
      print('haha');

      // a list that will replace the old list to avoid duplication
      List<Product> loadedProducts = [];

      // favorites list for that particular user

      url = Uri.parse(
          'https://flutter-shop-app-fa37c-default-rtdb.firebaseio.com/userFavorites/$userId/.json?auth=$authToken');
      final favoritesResponse = await http.get(url);
      final userFavoritesList = json.decode(favoritesResponse.body);

      if (productsList != null) {
        // go through each element and call a method that returns prodcuts from maps
        productsList.forEach((productId, productMap) {
          loadedProducts.add(
            Product.toProduct(
              productId,
              productMap,
              userFavoritesList == null
                  ? false
                  : userFavoritesList[productId] ?? false,
            ),
          );
        });
      }

      // replace the old list with the new one
      _products = loadedProducts;

      // notify all listeners

      notifyListeners();
    } catch (error) {
      // if there is an error rethrow the error
      rethrow;
    }
  }
}
