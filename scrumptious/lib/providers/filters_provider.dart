import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrumptious/data/globals.dart';
import 'package:scrumptious/models/meal.dart';
import 'package:scrumptious/providers/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
  nutFree,
  highProtein,
  lowCalorie,
  under30Mins,
  under1Hour,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false,
          Filter.nutFree: false,
          Filter.highProtein: false,
          Filter.lowCalorie: false,
          Filter.under30Mins: false,
          Filter.under1Hour: false,
        });

  void setFilter(Filter enumFilter, bool bIsActive) {
    state = {...state, enumFilter: bIsActive};
  }

  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
        (ref) => FiltersNotifier());

final filteredMealsProvider = Provider<List<Meal>>((ref) {
  final tempMeals = ref.watch(mealProvider);
  final activeFilters = ref.watch(filtersProvider);
  return filterMeals(tempMeals, activeFilters);
});
