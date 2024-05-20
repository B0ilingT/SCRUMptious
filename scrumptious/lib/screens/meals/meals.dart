import 'package:flutter/material.dart';
import 'package:scrumptious/data/temp_meals.dart';
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

  @override
  void initState() {
    super.initState();
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
    addMeal(mdlMeal);
  }

  void selectMeal(BuildContext context, Meal mdlMeal) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) =>
            MealDetailsScreen(mdlMeal: mdlMeal, addMeal: _addMeal)));
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
            Text("No meals found!",
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
        itemBuilder: ((context, index) => GestureDetector(
              onLongPress: () {
                // Show options
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Options'),
                      content: Text('Show your options here'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Option 1'),
                          onPressed: () {
                            // Handle Option 1
                          },
                        ),
                        TextButton(
                          child: Text('Option 2'),
                          onPressed: () {
                            // Handle Option 2
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: MealItem(
                mdlMeal: widget.arrMeals[index],
                mdlCategory: widget.mdlCategory,
                onSelectMeal: (mdlMeal) {
                  selectMeal(context, mdlMeal);
                },
              ),
            )),
      );
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
            if (widget.mdlCategory.strId != 'c0' &&
                widget.mdlCategory.strId != 'c-1')
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: _openSearchOverlay,
              ),
          ],
        ),
        body: content);
  }
}
