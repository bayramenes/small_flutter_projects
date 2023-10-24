import 'package:flutter/material.dart';

class CardItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CardItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'quantity': quantity,
      'price': price,
    };
  }
}

class CardProvider with ChangeNotifier {
  Map<String, CardItem> _cardItems = {};

  Map<String, CardItem> get cardItems {
    return {..._cardItems};
  }

  // get favorite item count

  int get getLength {
    return _cardItems.length;
  }

  // get the total price

  double get getTotal {
    double total = 0.0;
    _cardItems.forEach(
      (key, value) {
        total += value.price * value.quantity;
      },
    );
    return total;
  }

  void removeCardItem(String productId) {
    _cardItems.remove(productId);
    notifyListeners();
  }

  // remove an item from the list

  void removeSingleCardItem(String productId) {
    CardItem correspondingProduct = _cardItems[productId]!;
    if (correspondingProduct.quantity > 1) {
      _cardItems[productId] = CardItem(
        id: correspondingProduct.id,
        title: correspondingProduct.title,
        price: correspondingProduct.price,
        quantity: correspondingProduct.quantity - 1,
      );
    } else {
      _cardItems.remove(productId);
    }
    notifyListeners();
  }

  // add an item to the list of card items

  void addCardItem(String productId, String title, double price) {
    // if the product already exists than update it with the new quantity
    if (_cardItems.containsKey(productId)) {
      _cardItems.update(
        productId,
        (existingCardItem) => CardItem(
          id: existingCardItem.id,
          title: existingCardItem.title,
          price: existingCardItem.price,
          quantity: existingCardItem.quantity + 1,
        ),
      );
    }
    // if the product doesn't exist than add a new item
    else {
      _cardItems.putIfAbsent(
        productId,
        () => CardItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1),
      );
    }

    notifyListeners();
  }

  // clear when an order is placed

  void clear() {
    _cardItems.clear();
    notifyListeners();
  }
}
