import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import './card_provider.dart';

class OrderItem {
  String id;
  final List<CardItem> items;
  final double amount;
  final DateTime date;
  OrderItem({
    required this.id,
    required this.amount,
    required this.items,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  void changeId(String newId) {
    id = newId;
  }

  static toOrderItem(String orderId, Map<String, dynamic> orderMapToConvert) {
    return OrderItem(
      id: orderId,
      amount: orderMapToConvert['amount'],
      date: DateTime.parse(orderMapToConvert['date']),
      items: (orderMapToConvert['items'] as List<dynamic>)
          .map(
            (item) => CardItem(
              id: item['id'],
              title: item['title'],
              price: item['price'],
              quantity: item['quantity'],
            ),
          )
          .toList(),
    );
  }
}

class Orders with ChangeNotifier {
  final String? authToken;
  final String? userId;
  List<OrderItem> _orders = [];

  Orders(this.authToken, this.userId, this._orders);

  // return orders in a public fashion
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(OrderItem orderToAdd) async {
    final url = Uri.parse(
        'https://flutter-shop-app-fa37c-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          orderToAdd.toMap(),
        ),
      );

      orderToAdd.changeId(json.decode(response.body)['name']);
      _orders.insert(
        0,
        orderToAdd,
      );

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://flutter-shop-app-fa37c-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');

    final response = await http.get(url);

    if (response.body == 'null') {
      return;
    }

    List<OrderItem> loadedOrders = [];
    final Map<String, dynamic> extractedData = json.decode(response.body);

    extractedData.forEach(
      (orderId, orderData) {
        loadedOrders.add(
          OrderItem.toOrderItem(orderId, orderData),
        );
      },
    );
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
