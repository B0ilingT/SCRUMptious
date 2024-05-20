import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrumptious/data/temp_meals.dart';

// final storedMealsProvider = Provider<Future<String?>>((ref) async {
//   final storage = FlutterSecureStorage();
//   String? meals = await storage.read(key: 'meals');
//   return meals;
// });

// final dummyMealsProvider = Provider((ref) {
//   return dummyMeals;
// });

// final mealsProvider = Provider<Future<List<Meal>>>((ref) async {
//   final storedMeals = await ref.watch(storedMealsProvider);
//   final dummyMeals = ref.watch(dummyMealsProvider);

//   if (storedMeals == null) {
//     return dummyMeals;
//   }
// });

final mealsProvider = Provider((ref) {
  return tempMeals;
});
