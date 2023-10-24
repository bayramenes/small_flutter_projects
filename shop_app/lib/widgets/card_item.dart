import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/card_provider.dart';

class CardItemWidget extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;

  final String title;
  CardItemWidget({
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    print(id);
    final card = Provider.of<CardProvider>(context, listen: false);
    return Card(
      child: Dismissible(
        confirmDismiss: (direction) {
          return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    content: const Text(
                        'Are you sure you want to delete this item from the card ?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Yes'),
                      ),
                    ],
                  ));
        },
        onDismissed: (_) => card.removeCardItem(id),
        direction: DismissDirection.endToStart,
        key: ValueKey(id),
        background: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          alignment: Alignment.centerRight,
          color: Colors.red.shade900,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: FittedBox(
                child: Text(
                  "\$${price.toString()}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          title: Text(title),
          subtitle: Text('Total : \$${price * quantity}'),
          trailing: Text("X ${quantity}"),
        ),
      ),
    );
  }
}
