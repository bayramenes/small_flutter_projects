// packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// widgets
import '../widgets/card_item.dart';
// providers
import '../../providers/card_provider.dart';
import '../providers/orders_provider.dart';

class CardScreen extends StatefulWidget {
  static const routeName = '/card-screen';

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  bool isEmpty = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final card = Provider.of<CardProvider>(context);
    final orders = Provider.of<Orders>(context, listen: false);
    final cardItems = card.cardItems;
    isEmpty = cardItems.isEmpty ? true : false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Card'),
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      "\$${card.getTotal.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: isEmpty
                          ? null
                          : () async {
                              setState(() {
                                isLoading = true;
                              });
                              await orders.addOrder(
                                OrderItem(
                                  date: DateTime.now(),
                                  id: '',
                                  amount: card.getTotal,
                                  items: cardItems.values.toList(),
                                ),
                              );
                              setState(() {
                                isLoading = false;
                              });

                              card.clear();
                            },
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).accentColor,
                              ),
                            )
                          : Text(
                              'ORDER NOW',
                              style: TextStyle(
                                color: isEmpty
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor,
                              ),
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: card.getLength,
              itemBuilder: (BuildContext context, int index) {
                var currentItem = cardItems.values.toList()[index];
                return CardItemWidget(
                    id: cardItems.keys.toList()[index],
                    price: currentItem.price,
                    quantity: currentItem.quantity,
                    title: currentItem.title);
              },
            ),
          ),
        ],
      ),
    );
  }
}
