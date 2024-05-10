import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:scrumptious/models/category.dart';
import 'package:scrumptious/models/meal.dart';
import 'package:scrumptious/screens/meals/meal_details.dart';
import 'package:scrumptious/screens/meals/new_meal.dart';
import 'package:scrumptious/widgets/meals/meal_item.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({
    super.key,
    required this.arrMeals,
    required this.mdlCategory,
  });

  final Category mdlCategory;
  final List<Meal> arrMeals;

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final List<Meal> _arrMeals = [];
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    final String? mealDataString = await _storage.read(key: 'meals');
    if (mealDataString != null) {
      final List<Map<String, dynamic>> mealData =
          jsonDecode(mealDataString).cast<Map<String, dynamic>>();
      setState(() {
        _arrMeals.clear();
        _arrMeals.addAll(
          mealData.map((data) => Meal.fromJson(data)),
        );
      });
    }
  }

  Future<void> _savemeals() async {
    final List<Map<String, dynamic>> mealData =
        _arrMeals.map((meal) => meal.toJson()).toList();
    final String mealDataString = jsonEncode(mealData);
    await _storage.write(key: 'meals', value: mealDataString);
    await _storage.write(key: 'mealCount', value: _arrMeals.length.toString());
  }

  void _openSearchOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (ctx) => const NewMeal(),
      isScrollControlled: true,
    );
  }

  void _addMeal(Meal mdlMeal) {
    setState(() {
      _arrMeals.add(mdlMeal);
    });
    _savemeals();
  }

  void selectMeal(BuildContext context, Meal mdlMeal) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => MealDetailsScreen(
              mdlMeal: mdlMeal,
            )));
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    final String strTitle = widget.mdlCategory.strTitle;

    if (widget.arrMeals.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("looool... there's no meals here!",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            const SizedBox(height: 16),
            Text("Try selecting a different category!",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground))
          ],
        ),
      );
    } else {
      content = ListView.builder(
          itemCount: widget.arrMeals.length,
          itemBuilder: ((context, index) => MealItem(
                mdlMeal: widget.arrMeals[index],
                mdlCategory: widget.mdlCategory,
                onSelectMeal: (mdlMeal) {
                  selectMeal(context, mdlMeal);
                },
              )));
    }

    return Scaffold(
        appBar: AppBar(
          title: Hero(
            tag: widget.mdlCategory.strId,
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                strTitle,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _openSearchOverlay,
            )
          ],
        ),
        body: content);
  }
}
