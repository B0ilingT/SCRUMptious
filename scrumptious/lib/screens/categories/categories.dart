import 'package:flutter/material.dart';
import 'package:scrumptious/data/dummy_data.dart';
import 'package:scrumptious/models/category.dart';
import 'package:scrumptious/models/meal.dart';
import 'package:scrumptious/screens/meals/meals.dart';
import 'package:scrumptious/widgets/categories/category_grid_item.dart';
import 'package:scrumptious/widgets/main_drawer.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen(
    {
      super.key,
      required this.onToggleFavourite
    }
  );

  final void Function(Meal mdlMeal) onToggleFavourite;


  void _selectCategory(BuildContext context, Category mdlCategory) {
    final arrFilteredMeals = dummyMeals.where(
      (objMeal) => objMeal.arrCategories.contains(mdlCategory.strId)
    ).toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          mdlCategory: mdlCategory, 
          arrMeals: arrFilteredMeals,
          onToggleFavourite: onToggleFavourite,
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    // Layout control:
    SliverGridDelegateWithFixedCrossAxisCount grid =  const SliverGridDelegateWithFixedCrossAxisCount( 
      crossAxisCount: 2,
      childAspectRatio: 3 / 2,
      crossAxisSpacing: 20,
      mainAxisSpacing:  20,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick a "SCRUM"ptious Category'),
      ),
      drawer: const MainDrawer(),
      body: GridView(
        padding: const EdgeInsets.all(8),
        gridDelegate: grid,
        children: [
          for (final mdlCategory in availableCategories) 
            CategoryGridItem(
              mdlCategory: mdlCategory, 
              onSelectCategory: () {
                _selectCategory(context, mdlCategory);
              }
            )      
        ],
      )
    );
  }
}