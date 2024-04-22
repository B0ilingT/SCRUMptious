import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrumptious/models/meal.dart';

class FavouriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavouriteMealsNotifier() : super([]);

  bool toggleMealFavouriteStatus(Meal mdlMeal) {
    if (state.contains(mdlMeal)) {
      state = state.where((meal) => meal.strId != mdlMeal.strId).toList();
      return false;
    } else {
      state = [...state, mdlMeal];
      return true;
    }
  }
}

final favouriteMealsProvider = StateNotifierProvider<FavouriteMealsNotifier, List<Meal>>((ref) {
  return FavouriteMealsNotifier();
});