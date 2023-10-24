// packages

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// providers

import '../providers/orders_provider.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem order;
  OrderItemWidget(this.order);

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
            title: Text("\$${widget.order.amount.toString()}"),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date),
            ),
          ),
          if (_isExpanded)
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: widget.order.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.order.items[index].title),
                        Text(
                            "${widget.order.items[index].quantity} X ${widget.order.items[index].price}")
                      ],
                    ),
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}
