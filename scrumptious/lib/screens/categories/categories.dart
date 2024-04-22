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
      required this.onSetScreen,
      required this.availableMeals
    }
  );
  final List<Meal> availableMeals;
  final void Function(String strIdentifier) onSetScreen;

  void _selectCategory(BuildContext context, Category mdlCategory) {
    final arrFilteredMeals = availableMeals.where(
      (objMeal) => objMeal.arrCategories.contains(mdlCategory.strId)
    ).toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          mdlCategory: mdlCategory, 
          arrMeals: arrFilteredMeals,
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
      drawer: MainDrawer(onTapDrawerTile: onSetScreen),
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