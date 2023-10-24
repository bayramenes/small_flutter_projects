import 'package:flutter/material.dart';

import '../../dummy_data.dart';
import './category_item.dart';

class CategoriesScreen extends StatelessWidget {
  static const routeName = '/categories';

  @override
  Widget build(BuildContext context) {
    return GridView(
      children: DUMMY_CATEGORIES
          .map((categoryData) => CategoryItem(
                id: categoryData.id,
                color: categoryData.color,
                title: categoryData.title,
              ))
          .toList(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 3 / 2),
    );
  }
}
