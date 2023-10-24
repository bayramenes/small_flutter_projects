import 'package:flutter/material.dart';

import '../../models/meal.dart';
import '../meal_detail_screen/meal_detail_screen.dart';

class MealItem extends StatefulWidget {
  final Meal meal;

  MealItem(this.meal);

  @override
  State<MealItem> createState() => _MealItemState();
}

class _MealItemState extends State<MealItem> {
  // when a user taps on a certain meal who the detail page
  void selectMeal(
      {required BuildContext ctx,
      required String title,
      required String imageUrl}) {
    Navigator.of(ctx).pushNamed(
      MealDetailScreen.routeName,
      arguments: widget.meal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () => selectMeal(
          ctx: context,
          imageUrl: widget.meal.imageUrl,
          title: widget.meal.title),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    widget.meal.imageUrl,
                    height: 250,
                    fit: BoxFit.fill,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 40,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.black45,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      widget.meal.title,
                      style: Theme.of(context).textTheme.subtitle2,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MealBottomInfo(
                      icon: const Icon(Icons.schedule),
                      title: "${widget.meal.duration} min"),
                  MealBottomInfo(
                      icon: const Icon(Icons.work),
                      title: widget.meal.complexity.name),
                  MealBottomInfo(
                      icon: const Icon(Icons.attach_money),
                      title: widget.meal.affordability.name),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MealBottomInfo extends StatelessWidget {
  final Icon icon;
  final String title;
  MealBottomInfo({required this.icon, required this.title});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(title),
        ),
      ],
    );
  }
}
