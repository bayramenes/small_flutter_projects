// packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// screens
import './screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/card_screen.dart';
import './screens/orders_screen.dart';
import './screens/manage_products_screen.dart';
import './screens/product_add_or_edit_screen.dart';
import './screens/auth_screen.dart';

// providers
import './providers/products_provider.dart';
import './providers/card_provider.dart';
import './providers/orders_provider.dart';
import './providers/auth_provider.dart';

// themes
import './theme/ThemeClass.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          update: (context, auth, previousData) => ProductsProvider(
            auth.token,
            auth.userId,
            previousData!.products.isEmpty ? [] : previousData.products,
          ),
          create: (ctx) => ProductsProvider('', '', []),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CardProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, Orders>(
          update: (context, auth, previousData) => Orders(
              auth.token,
              auth.userId,
              previousData!.orders.isEmpty ? [] : previousData.orders),
          create: (ctx) => Orders('', '', []),
        )
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeClass.lightTheme,
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return AuthScreen();
                  },
                ),
          routes: {
            AuthScreen.routeName: (ctx) => AuthScreen(),
            ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CardScreen.routeName: (ctx) => CardScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            ManageProductsScreen.routeName: (ctx) => ManageProductsScreen(),
            ProductAddEditScreen.routeName: (ctx) => ProductAddEditScreen(),
          },
        ),
      ),
    );
  }
}
