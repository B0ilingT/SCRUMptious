import 'package:flutter/material.dart';
import 'package:scrumptious/models/meal.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen(
    {
      super.key,
      required this.strTitle,
      required this.arrMeals
    }
  );

  final String strTitle;
  final List<Meal> arrMeals;

  @override
  Widget build(BuildContext context) {
    Widget content;

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
          (context, index) => Text(
            arrMeals[index].strTitle
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