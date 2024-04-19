import 'package:flutter/material.dart';
import 'package:scrumptious/models/meal.dart';

class MealDetailsScreen extends StatelessWidget{
  const MealDetailsScreen(
    {
      super.key,
      required this.mdlMeal,
    }
  );

  final Meal mdlMeal;

  String _getStepText(String strStep) {
    int intStepNumber = mdlMeal.arrSteps.indexOf(strStep) + 1;
    return '$intStepNumber. $strStep';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mdlMeal.strTitle)
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              mdlMeal.strImageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 14),
            Text(
              'Ingredients',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 14),
            for (final ingredient in mdlMeal.arrIngredients)
              Text(
                ingredient,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground
                ),
              ),
            const SizedBox(height: 24),
            Text(
              'Steps',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 16),
            for (final step in mdlMeal.arrSteps)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  12,
                  0,
                  12,
                  16
                ),
                child: Text(
                  _getStepText(step),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}