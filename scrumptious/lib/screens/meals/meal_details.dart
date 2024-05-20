import 'package:flutter/material.dart';
import 'package:scrumptious/models/meal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrumptious/providers/favourites_provider.dart';

class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen(
      {super.key, required this.mdlMeal, required this.addMeal});

  final Meal mdlMeal;
  final void Function(Meal) addMeal;

  String _getStepText(String strStep) {
    int intStepNumber = mdlMeal.arrSteps.indexOf(strStep) + 1;
    return '$intStepNumber. $strStep';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouriteMeals = ref.watch(favouriteMealsProvider);
    final bIsFavourite = favouriteMeals.contains(mdlMeal);

    return Scaffold(
      appBar: AppBar(
        title: Text(mdlMeal.strTitle),
        actions: [
          mdlMeal.arrCategories.contains('c-1')
              ? IconButton(
                  onPressed: () {
                    addMeal(mdlMeal);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Meal added!"),
                    ));
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: const Icon(
                      Icons.add,
                      key: ValueKey(true),
                    ),
                  ),
                )
              : IconButton(
                  onPressed: () {
                    final bWasAdded = ref
                        .read(favouriteMealsProvider.notifier)
                        .toggleMealFavouriteStatus(mdlMeal);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(bWasAdded
                          ? "Added meal to favourites!"
                          : "Meal is no longer a favourite!"),
                    ));
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      bIsFavourite ? Icons.star : Icons.star_border,
                      key: ValueKey(bIsFavourite),
                    ),
                  ),
                )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
                tag: mdlMeal.strId,
                child: mdlMeal.arrCategories.contains('c-1')
                    ? Image.network(
                        mdlMeal.strImageUrl,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        mdlMeal.strImageUrl,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )),
            const SizedBox(height: 14),
            Text(
              'Ingredients',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            for (final ingredient in mdlMeal.arrIngredients)
              Text(
                ingredient,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            const SizedBox(height: 24),
            Text(
              'Steps',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            for (final step in mdlMeal.arrSteps)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                child: Text(
                  _getStepText(step),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
