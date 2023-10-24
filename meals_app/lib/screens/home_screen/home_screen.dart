import 'package:flutter/material.dart';

import '../categories_screen/categories_screen.dart';
import '../favorites_screen/favorites_screen.dart';
import './home_drawer.dart';
import '../../models/meal.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';
  List<Meal> favoriteMeals;

  HomeScreen(this.favoriteMeals);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, Object>>? _tabBarPages;
  @override
  void initState() {
    _tabBarPages = [
      {'page': CategoriesScreen(), 'title': 'Categories'},
      {'page': FavoritesScreen(widget.favoriteMeals), 'title': 'Favorites'},
    ];
    super.initState();
  }

  int _currentPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: HomeDrawer(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) => _selectPage(index),
        currentIndex: _currentPageIndex,
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(_tabBarPages![_currentPageIndex]['title'] as String),
      ),
      body: Padding(
          padding: const EdgeInsets.only(top: 8, right: 5, left: 5, bottom: 0),
          child: _tabBarPages![_currentPageIndex]['page'] as Widget),
    );
  }
}
