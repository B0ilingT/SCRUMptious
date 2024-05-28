import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrumptious/data/temp_meals.dart';
import 'package:scrumptious/models/meal.dart';

class MealNotifier extends StateNotifier<List<Meal>> {
  MealNotifier()
      : super(
          tempMeals.toList(),
        );

  void addMeal(Meal mdlMeal) {
    state.add(mdlMeal);
  }

  void updateMeals(List<Meal> newMeals) {
    state = [...state, ...newMeals];
  }
}

final mealProvider =
    StateNotifierProvider<MealNotifier, List<Meal>>((ref) => MealNotifier());
