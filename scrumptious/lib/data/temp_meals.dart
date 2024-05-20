import 'package:scrumptious/models/meal.dart';

List<Meal> tempMeals = [];

void addMeal(Meal meal) {
  tempMeals.add(meal);
}

void addAllMeals(List<Meal> arrMeals) {
  tempMeals.addAll(arrMeals);
}

void removeMeal(Meal meal) {
  tempMeals.remove(meal);
}

void removeAllMeals() {
  tempMeals.clear();
}