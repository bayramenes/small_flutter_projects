import 'package:flutter/material.dart';

import '../../models/meal.dart';
import '../category_meal_screen/meal_item.dart';

class FavoritesScreen extends StatelessWidget {
  List<Meal> favoritesList;
  FavoritesScreen(this.favoritesList);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: favoritesList.isEmpty
          ? const Center(
              child: Text('You have no favorites - add recipes now!!'),
            )
          : ListView.builder(
              itemCount: favoritesList.length,
              itemBuilder: (ctx, index) => MealItem(favoritesList[index]),
            ),
    );
  }
}
