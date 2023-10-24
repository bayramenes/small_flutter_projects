import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';

import '../../dummy_data.dart';
import './meal_item.dart';

class CategoryMealScreen extends StatefulWidget {
  static const routeName = '/Category-screen';

  List<Meal> availableMeals;
  CategoryMealScreen(this.availableMeals);

  @override
  State<CategoryMealScreen> createState() => _CategoryMealScreenState();
}

class _CategoryMealScreenState extends State<CategoryMealScreen> {
  String? title;
  String? id;

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    title = routeArgs['title'];
    id = routeArgs['id'];

    List<Meal> categoryMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(id))
        .toList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView.builder(
          itemCount: categoryMeals.length,
          itemBuilder: (ctx, index) => MealItem(categoryMeals[index]),
        ),
      ),
    );
  }
}
