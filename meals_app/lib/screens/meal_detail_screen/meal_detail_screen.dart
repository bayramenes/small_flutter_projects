import 'package:flutter/material.dart';

import '../../models/meal.dart';

class MealDetailScreen extends StatefulWidget {
  static const routeName = "/meal-detail";

  final Function favoriteToggleHandler;
  List<Meal> favoriteMeals;

  MealDetailScreen(this.favoriteToggleHandler, this.favoriteMeals);

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final Meal selectedMeal =
        ModalRoute.of(context)!.settings.arguments as Meal;

    bool isFavorite =
        widget.favoriteMeals.contains(selectedMeal) ? true : false;

    // build the ingredients and steps title to aviod repetition
    Widget buildTitle(String text) {
      return Center(
        child: Text(
          text,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 25),
        ),
      );
    }

    Widget buildList({required Widget child}) {
      return Container(
        padding: const EdgeInsets.all(2),
        margin: const EdgeInsets.all(7),
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          border: Border.all(
              style: BorderStyle.solid, color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(15),
        ),
        child: child,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedMeal.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Image.network(selectedMeal.imageUrl),
            ),
            buildTitle('Ingredients'),
            //
            buildList(
                child: ListView.builder(
              itemCount: selectedMeal.ingredients.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 7),
                  padding: const EdgeInsets.all(6),
                  child: Center(
                    child: Text(
                      selectedMeal.ingredients[index],
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                );
              },
            )),

            buildTitle(
              'Steps',
            ),
            buildList(
              child: ListView.builder(
                itemCount: selectedMeal.steps.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).accentColor,
                          foregroundColor: Colors.white,
                          child: Text(
                            (index + 1).toString(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                          ),
                        ),
                        title: Text(
                          selectedMeal.steps[index],
                        ),
                      ),
                      Divider()
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: isFavorite == true ? Icon(Icons.star) : Icon(Icons.star_border),
        onPressed: () {
          widget.favoriteToggleHandler(selectedMeal.id);
        },
      ),
    );
  }
}
