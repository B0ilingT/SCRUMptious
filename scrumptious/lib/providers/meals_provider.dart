import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrumptious/models/meal.dart';
import 'package:scrumptious/data/temp_meals.dart';

final tempMealsProvider = Provider<List<Meal>>((ref) => tempMeals);

class MealsNotifier extends StateNotifier<List<Meal>> {
  MealsNotifier(List<Meal> meals) : super(meals);
}

final mealsProvider =
    StateNotifierProvider.family<MealsNotifier, List<Meal>, void>((ref, _) {
  final meals = ref.watch(tempMealsProvider);
  return MealsNotifier(meals);
});
