import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrumptious/data/temp_meals.dart';
import 'package:scrumptious/models/meal.dart';

final mealsProvider = Provider((ref) {
  return tempMeals;
});

class TempMealsNotifier extends StateNotifier<List<Meal>> {
  TempMealsNotifier()
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

final tempMealProvider = StateNotifierProvider<TempMealsNotifier, List<Meal>>(
    (ref) => TempMealsNotifier());
