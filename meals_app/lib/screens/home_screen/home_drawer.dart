import 'package:flutter/material.dart';

import 'package:meals_app/screens/home_screen/home_screen.dart';
import '../filters_screen/filters_screen.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget buildButtonLink(
        {required Icon icon, required String label, required String PageName}) {
      return ListTile(
        leading: icon,
        title: Text(label),
        onTap: () {
          Navigator.of(context).pushReplacementNamed(PageName);
        },
      );
    }

    MediaQueryData mediaquery = MediaQuery.of(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          color: Theme.of(context).accentColor,
          alignment: Alignment.centerLeft,
          height: mediaquery.size.height * 0.18,
          child: Text(
            "Cooking Up!",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 30,
                fontWeight: FontWeight.w900),
          ),
        ),
        buildButtonLink(
            icon: const Icon(Icons.restaurant),
            label: 'Meals',
            PageName: HomeScreen.routeName),
        buildButtonLink(
            icon: const Icon(Icons.settings),
            label: 'Filters',
            PageName: FiltersScreen.routeName),
      ],
    );
  }
}
