import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:scrumptious/data/dummy_data.dart';
import 'package:scrumptious/data/temp_meals.dart';
import 'package:scrumptious/models/category.dart';
import 'package:scrumptious/models/meal.dart';
import 'package:scrumptious/providers/favourites_provider.dart';
import 'package:scrumptious/providers/meals_provider.dart';
import 'package:scrumptious/screens/meals/meal_details.dart';
import 'package:scrumptious/screens/meals/scrape_meal.dart';
import 'package:scrumptious/widgets/meals/meal_item.dart';

class MealsScreen extends ConsumerStatefulWidget {
  const MealsScreen({
    super.key,
    required this.arrMeals,
    required this.mdlCategory,
  });

  final Category mdlCategory;
  final List<Meal> arrMeals;

  @override
  ConsumerState<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends ConsumerState<MealsScreen> {
  final List<Meal> _arrMeals = [];

  @override
  void initState() {
    super.initState();
  }

  void _openSearchOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (ctx) => const ScrapeMeal(),
      isScrollControlled: true,
    );
  }

  Future<void> _showMultiSelect(BuildContext context, Meal mdlMeal) async {
    if (mdlMeal.arrCategories.contains('c-1')) {
      mdlMeal.arrCategories.remove('c-1');
    }

    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
          title:
              const Text('Categories:', style: TextStyle(color: Colors.white)),
          confirmText:
              const Text('Confirm', style: TextStyle(color: Colors.white)),
          cancelText:
              const Text('Cancel', style: TextStyle(color: Colors.white)),
          itemsTextStyle: const TextStyle(color: Colors.white),
          selectedItemsTextStyle: const TextStyle(color: Colors.white),
          items: availableCategories
              .map((category) =>
                  MultiSelectItem(category.strId, category.strTitle))
              .toList(),
          initialValue: mdlMeal.arrCategories,
          onConfirm: (values) {
            setState(() {
              mdlMeal.arrCategories.addAll(values.cast<String>());
            });
            ref.read(mealProvider.notifier).updateMeals([mdlMeal]);
          },
        );
      },
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
    final favouriteMeals = ref.watch(favouriteMealsProvider);

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
        itemBuilder: ((context, index) => Slidable(
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: <Widget>[
                  IconTheme(
                    data: const IconThemeData(size: 50),
                    child: SlidableAction(
                      icon: favouriteMeals.contains(widget.arrMeals[index])
                          ? Icons.star
                          : Icons.star_border,
                      onPressed: (context) {
                        final bWasAdded = ref
                            .read(favouriteMealsProvider.notifier)
                            .toggleMealFavouriteStatus(widget.arrMeals[index]);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(bWasAdded
                              ? "Added meal to favourites!"
                              : "Meal is no longer a favourite!"),
                        ));
                      },
                      backgroundColor: const Color.fromARGB(255, 255, 187, 0),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: <Widget>[
                  IconTheme(
                    data: const IconThemeData(size: 50),
                    child: SlidableAction(
                      icon: widget.mdlCategory.strId == 'c-1'
                          ? Icons.add
                          : Icons.delete,
                      onPressed: (context) async {
                        final meal = widget.arrMeals[index];
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        if (widget.mdlCategory.strId == 'c-1') {
                          await _showMultiSelect(context, meal);
                          if (mounted) {
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                content: Text("Meal added successfully"),
                              ),
                            );
                          }
                        } else {
                          final removedMealIndex = index;
                          meal.arrCategories.remove(widget.mdlCategory.strId);
                          setState(() {
                            widget.arrMeals.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Meal was removed from ${widget.mdlCategory.strTitle}"),
                              action: SnackBarAction(
                                label: 'UNDO',
                                onPressed: () {
                                  setState(() {
                                    meal.arrCategories
                                        .add(widget.mdlCategory.strId);
                                    widget.arrMeals
                                        .insert(removedMealIndex, meal);
                                  });
                                },
                              ),
                            ),
                          );
                        }
                      },
                      backgroundColor: widget.mdlCategory.strId == 'c-1'
                          ? Colors.blue
                          : const Color.fromARGB(171, 255, 0, 0),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
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
