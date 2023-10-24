// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// screens
import '../screens/manage_products_screen.dart';

import '../screens/product_overview_screen.dart';
import '../screens/orders_screen.dart';

import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget buildNavigationButton(String routename, String label, Icon icon) {
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: icon,
            trailing: Text(label),
            onTap: () => Navigator.of(context).pushReplacementNamed(routename),
          ));
    }

    return Drawer(
        child: Column(
      children: [
        Container(
          width: double.infinity,
          height: 50,
          color: Theme.of(context).primaryColor,
          child: const Center(
            child: Text(
              'Shop App',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
        buildNavigationButton(
          ProductOverviewScreen.routeName,
          'Shop',
          const Icon(Icons.shop),
        ),
        buildNavigationButton(
          OrdersScreen.routeName,
          'Orders',
          const Icon(Icons.payment),
        ),
        buildNavigationButton(
          ManageProductsScreen.routeName,
          'Manage Products',
          const Icon(Icons.edit),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: const Icon(Icons.logout),
            trailing: Text('LogOut'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<AuthProvider>(context, listen: false).logOut();
            },
          ),
        ),
      ],
    ));
  }
}
