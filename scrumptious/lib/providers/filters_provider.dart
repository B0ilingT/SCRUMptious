import 'package:flutter_riverpod/flutter_riverpod.dart';
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

final filteredMealsProvider = Provider((ref) {
  final arrMeals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);

  return arrMeals.where((meal) {
    if (activeFilters[Filter.glutenFree]! && !meal.bIsGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !meal.bIsLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegetarian]! && !meal.bIsVegetarian) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !meal.bIsVegan) {
      return false;
    }
    if (activeFilters[Filter.nutFree]! && !meal.bIsNutFree) {
      return false;
    }
    if (activeFilters[Filter.highProtein]! && !meal.bIsHighProtein) {
      return false;
    }
    if (activeFilters[Filter.lowCalorie]! && !meal.bIsLowCalorie) {
      return false;
    }
    if (activeFilters[Filter.under30Mins]! && !meal.bIsUnder30Mins) {
      return false;
    }
    if (activeFilters[Filter.under1Hour]! && !meal.bIsUnder1Hour) {
      return false;
    }
    return true;
  }).toList();
});
