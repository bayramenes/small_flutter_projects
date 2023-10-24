// packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// widgets
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

// providers
import '../providers/orders_provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: FutureBuilder(
        future: orders.fetchAndSetOrders(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).accentColor,
              ),
            );
          } else {
            if (snapshot.error != null) {
              return const Center(
                child: Text('An error occured :('),
              );
            } else {
              return ListView.builder(
                itemCount: orders.orders.length,
                itemBuilder: (BuildContext context, int index) {
                  return OrderItemWidget(orders.orders[index]);
                },
              );
            }
          }
        },
      ),
    );
  }
}
