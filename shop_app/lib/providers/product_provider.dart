import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;
  // bool isInCard;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
    // this.isInCard = false,
  });

  void changeId(String newId) {
    id = newId;
  }

  void changeTitle(String newTitle) {
    title = newTitle;
  }

  void changeDescription(String newDescription) {
    description = newDescription;
  }

  void changePrice(double newPrice) {
    price = newPrice;
  }

  void changeImageUrl(String newImageUrl) {
    imageUrl = newImageUrl;
  }

  Future<void> toggleFavoriteStatus(authToken, userId) async {
    final url = Uri.parse(
        'https://flutter-shop-app-fa37c-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken');

    var oldStatus = isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();

    final response = await http.put(
      url,
      body: json.encode(
        isFavorite,
      ),
    );
    if (response.statusCode >= 400) {
      isFavorite = oldStatus;
      notifyListeners();
      throw HttpException(isFavorite
          ? "couldn't remove from favorites!!"
          : "couldn't add to favorites!!");
    }
  }

  Map<String, dynamic> toMap(String userId) {
    return {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'userId': userId,
    };
  }

  static Product toProduct(
    String productId,
    Map<String, dynamic> mapToConvert,
    bool favoriteStatus,
  ) {
    return Product(
      id: productId,
      description: mapToConvert['description'],
      imageUrl: mapToConvert['imageUrl'],
      price: mapToConvert['price'],
      title: mapToConvert['title'],
      isFavorite: favoriteStatus,
    );
  }
}
