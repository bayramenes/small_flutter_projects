import 'package:flutter/material.dart';

import 'screens/category_meal_screen/category_meal_screen.dart';
import './theme/themeClass.dart';
import './screens/meal_detail_screen/meal_detail_screen.dart';
import './screens/home_screen/home_screen.dart';
import './screens/filters_screen/filters_screen.dart';
import './dummy_data.dart';
import './models/meal.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // a list of favorite meals that were toggled as favorite by the user
  List<Meal> _favorites = [];

  // add or remove a certian meal from the favorites page

  void favoriteMealToggled(String mealId) {
    Meal matchingMeal = _favorites.firstWhere((meal) {
      if (meal.id == mealId) {
        setState(() {
          _favorites.removeWhere((mealToRemove) => mealToRemove.id == mealId);
        });

        return true;
      }
      return false;
    }, orElse: () {
      Meal mealToAdd =
          DUMMY_MEALS.firstWhere((dummyMeal) => dummyMeal.id == mealId);
      setState(() {
        _favorites.add(mealToAdd);
      });
      return mealToAdd;
    });

    // print(matchingMeal);
  }

  // a map of the filters that are used by the user right now
  Map<String, bool> _filters = {
    "gluten": false,
    "lactose": false,
    "vegan": false,
    "vegetarian": false
  };

  // display the available meals as all of the dummy meals from the data source
  List<Meal> availableMeals = DUMMY_MEALS;

  // a function which takes the new filters that are coming from the filters screen widget to it as a map and
  // changes the initial list to the new one
  // and then updates the available meals list so that it has the meals according to the filters selected
  void _filterMeals(Map<String, bool> newFilters) {
    _filters = newFilters;

    setState(() {
      availableMeals = DUMMY_MEALS.where((meal) {
        if (newFilters['gluten']! && !meal.isGlutenFree) {
          return false;
        }
        if (_filters['lactose']! && !meal.isLactoseFree) {
          return false;
        }
        if (_filters['vegan']! && !meal.isVegan) {
          return false;
        }
        if (_filters['vegetarian']! && !meal.isVegetarian) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeClass.lightTheme,
      initialRoute: '/',
      routes: {
        HomeScreen.routeName: (ctx) => HomeScreen(_favorites),
        CategoryMealScreen.routeName: (ctx) =>
            CategoryMealScreen(availableMeals),
        MealDetailScreen.routeName: (ctx) =>
            MealDetailScreen(favoriteMealToggled, _favorites),
        FiltersScreen.routeName: (ctx) => FiltersScreen(_filterMeals, _filters),
      },
    );
  }
}
