library globals;

import 'package:scrumptious/models/meal.dart';
import 'package:scrumptious/providers/filters_provider.dart';

// Constants
const String strMealsTitle = "All Meals";
const String strAddMealTitle = "Add Meal";
const String strFiltersTitle = "Filters";

// Functions
String capitalizeString(String s) {
  if (s.isEmpty) {
    return s;
  }
  return s[0].toUpperCase() + s.substring(1);
}

String getAffordabilitySign(Affordability enumAffordability) {
  switch (enumAffordability) {
    case Affordability.affordable:
      return '£';
    case Affordability.pricey:
      return '££';
    case Affordability.luxurious:
      return '£££';
    default:
      return '';
  }
}

Affordability stringToAffordability(String str) {
  return Affordability.values.firstWhere((e) => e.toString() == str,
      orElse: () => Affordability.affordable);
}

Complexity stringToComplexity(String str) {
  return Complexity.values
      .firstWhere((e) => e.toString() == str, orElse: () => Complexity.simple);
}

String getAffordabilityText(Meal mdlMeal) {
  if (mdlMeal.arrCategories.contains('c-1')) {
    return '';
  }

  String strName = mdlMeal.enumAffordability.name;
  return capitalizeString(strName);
}

String getComplexityText(Meal mdlMeal) {
  String strName = mdlMeal.enumComplexity.name;
  return capitalizeString(strName);
}

List<Meal> filterMeals(List<Meal> arrMeals, Map<Filter, bool> arrFilters) {
  return arrMeals.where((meal) {
    if (arrFilters[Filter.glutenFree]! && !meal.bIsGlutenFree) {
      return false;
    }
    if (arrFilters[Filter.lactoseFree]! && !meal.bIsLactoseFree) {
      return false;
    }
    if (arrFilters[Filter.vegetarian]! && !meal.bIsVegetarian) {
      return false;
    }
    if (arrFilters[Filter.vegan]! && !meal.bIsVegan) {
      return false;
    }
    if (arrFilters[Filter.nutFree]! && !meal.bIsNutFree) {
      return false;
    }
    if (arrFilters[Filter.highProtein]! && !meal.bIsHighProtein) {
      return false;
    }
    if (arrFilters[Filter.lowCalorie]! && !meal.bIsLowCalorie) {
      return false;
    }
    if (arrFilters[Filter.under30Mins]! && !meal.bIsUnder30Mins) {
      return false;
    }
    if (arrFilters[Filter.under1Hour]! && !meal.bIsUnder1Hour) {
      return false;
    }
    return true;
  }).toList();
}
