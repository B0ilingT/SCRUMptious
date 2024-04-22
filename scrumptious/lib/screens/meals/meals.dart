import 'package:flutter/material.dart';
import 'package:scrumptious/models/category.dart';
import 'package:scrumptious/models/meal.dart';
import 'package:scrumptious/screens/meals/meal_details.dart';
import 'package:scrumptious/widgets/main_drawer.dart';
import 'package:scrumptious/widgets/meals/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen(
    {
      super.key,
      required this.arrMeals,
      required this.mdlCategory,
      required this.onToggleFavourite,
    }
  );

  final Category mdlCategory;
  final List<Meal> arrMeals;
  final void Function(Meal mdlMeal) onToggleFavourite;

  void selectMeal(BuildContext context, Meal mdlMeal){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealDetailsScreen(
          mdlMeal: mdlMeal,
          onToggleFavourite: onToggleFavourite ,
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    final String strTitle = mdlCategory.strTitle;

    if (arrMeals.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "looool... there's no meals here!",
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground
              )
            ),
            const SizedBox(height: 16),
            Text(
              "Try selecting a different category!",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground
              )
            )
          ],
        ),
      );
    } else {
      content = ListView.builder(
        itemCount: arrMeals.length,
        itemBuilder: (
          (context, index) => MealItem(
            mdlMeal: arrMeals[index], 
            mdlCategory: mdlCategory, 
            onSelectMeal: (mdlMeal){
              selectMeal(context, mdlMeal);
            },
          )
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(strTitle),
      ),
      body: content
    );
  }
}