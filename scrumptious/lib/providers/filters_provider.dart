import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrumptious/providers/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier() : super({
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegetarian: false,
    Filter.vegan: false,
  });

  void setFilter(Filter enumFilter, bool bIsActive) {
    state = {
      ...state, 
      enumFilter: bIsActive
    };
  }
  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }
}

final filtersProvider = StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
  (ref) => FiltersNotifier()
);

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
      return true;
    }).toList();
});