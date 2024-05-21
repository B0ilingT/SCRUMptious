import 'package:flutter/material.dart';
import 'package:scrumptious/Functions/good_food_scraper.dart';
import 'package:scrumptious/providers/filters_provider.dart';
import 'package:scrumptious/screens/meals/meals.dart';
import 'package:scrumptious/screens/shared/tabs.dart';
import 'package:uuid/uuid.dart';
import 'package:scrumptious/models/category.dart';
import 'package:scrumptious/models/meal.dart';

var uuid = const Uuid();

class NewMeal extends StatefulWidget {
  const NewMeal({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewMealState();
  }
}

class _NewMealState extends State<NewMeal> {
  Future<void>? _searchFuture;
  final _titleController = TextEditingController();
  Map<Filter, bool> activeFilters = {
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegetarian: false,
    Filter.vegan: false,
    Filter.nutFree: false,
    Filter.highProtein: false,
    Filter.lowCalorie: false,
    Filter.under30Mins: false,
    Filter.under1Hour: false
  };

  Category searchResults = const Category(
      strId: 'c-1',
      strTitle: 'Results',
      colour: Color.fromARGB(255, 140, 0, 255));

  Future _submitMealData() async {
    final arrMeals =
        await scrapeBBCGoodFood(_titleController.text, activeFilters);

    if (mounted) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => MealsScreen(
                mdlCategory: searchResults,
                arrMeals: arrMeals,
              )));
    }
  }

  List<Meal> filterMeals(List<Meal> arrMeals) {
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
  }

  void updateFilter(Filter filterType, bool newValue) {
    setState(() {
      activeFilters[filterType] = newValue;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SizedBox(
        height: double.infinity,
        child: Container(
          color: Theme.of(context).colorScheme.background,
          width: double.infinity,
          child: SingleChildScrollView(
            clipBehavior: Clip.hardEdge,
            child: Container(
              width: width,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, keyboardSpace + 16),
                  child: Column(children: [
                    TextField(
                      controller: _titleController,
                      enableSuggestions: true,
                      maxLength: 50,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        label: Text("Search:",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        helperStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(children: [
                      TextButton(
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const TabsScreen()),
                              );
                            }
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _searchFuture = _submitMealData();
                          });
                        },
                        child: FutureBuilder(
                          future: _searchFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              );
                            } else {
                              return const Text(
                                'Search',
                                style: TextStyle(color: Colors.white),
                              );
                            }
                          },
                        ),
                      ),
                    ]),
                    SwitchListTile(
                      value: activeFilters[Filter.glutenFree]!,
                      onChanged: (bIsChecked) {
                        updateFilter(Filter.glutenFree, bIsChecked);
                      },
                      title: Text('Gluten-free',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                      subtitle: Text('Only include gluten-free meals.',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                      activeColor: Theme.of(context).colorScheme.tertiary,
                      contentPadding:
                          const EdgeInsets.only(left: 34, right: 22),
                    ),
                    SwitchListTile(
                      value: activeFilters[Filter.lactoseFree]!,
                      onChanged: (bIsChecked) {
                        updateFilter(Filter.lactoseFree, bIsChecked);
                      },
                      title: Text('Lactose-free',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                      subtitle: Text('Only include lactose-free meals.',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                      activeColor: Theme.of(context).colorScheme.tertiary,
                      contentPadding:
                          const EdgeInsets.only(left: 34, right: 22),
                    ),
                    SwitchListTile(
                      value: activeFilters[Filter.nutFree]!,
                      onChanged: (bIsChecked) {
                        updateFilter(Filter.nutFree, bIsChecked);
                      },
                      title: Text('Nut-free',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                      subtitle: Text('Only include nut-free meals.',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                      activeColor: Theme.of(context).colorScheme.tertiary,
                      contentPadding:
                          const EdgeInsets.only(left: 34, right: 22),
                    ),
                    SwitchListTile(
                      value: activeFilters[Filter.vegetarian]!,
                      onChanged: (bIsChecked) {
                        updateFilter(Filter.vegetarian, bIsChecked);
                      },
                      title: Text('Vegetarian',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                      subtitle: Text('Only include vegetarian friendly meals.',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                      activeColor: Theme.of(context).colorScheme.tertiary,
                      contentPadding:
                          const EdgeInsets.only(left: 34, right: 22),
                    ),
                    SwitchListTile(
                      value: activeFilters[Filter.vegan]!,
                      onChanged: (bIsChecked) {
                        updateFilter(Filter.vegan, bIsChecked);
                      },
                      title: Text('Vegan',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                      subtitle: Text('Only include vegan friendly meals.',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                      activeColor: Theme.of(context).colorScheme.tertiary,
                      contentPadding:
                          const EdgeInsets.only(left: 34, right: 22),
                    ),
                    SwitchListTile(
                      value: activeFilters[Filter.highProtein]!,
                      onChanged: (bIsChecked) {
                        updateFilter(Filter.highProtein, bIsChecked);
                      },
                      title: Text('High Protein',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                      subtitle: Text('Only include high protein meals.',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                      activeColor: Theme.of(context).colorScheme.tertiary,
                      contentPadding:
                          const EdgeInsets.only(left: 34, right: 22),
                    ),
                    SwitchListTile(
                      value: activeFilters[Filter.lowCalorie]!,
                      onChanged: (bIsChecked) {
                        updateFilter(Filter.lowCalorie, bIsChecked);
                      },
                      title: Text('Low Calorie',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                      subtitle: Text('Only include low calorie meals.',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                      activeColor: Theme.of(context).colorScheme.tertiary,
                      contentPadding:
                          const EdgeInsets.only(left: 34, right: 22),
                    ),
                    SwitchListTile(
                      value: activeFilters[Filter.under30Mins]!,
                      onChanged: (bIsChecked) {
                        updateFilter(Filter.under30Mins, bIsChecked);
                      },
                      title: Text('< 30 mins',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                      subtitle: Text('Only include that take under 30 minutes.',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                      activeColor: Theme.of(context).colorScheme.tertiary,
                      contentPadding:
                          const EdgeInsets.only(left: 34, right: 22),
                    ),
                    SwitchListTile(
                      value: activeFilters[Filter.under1Hour]!,
                      onChanged: (bIsChecked) {
                        updateFilter(Filter.under1Hour, bIsChecked);
                      },
                      title: Text('< 1 hour',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                      subtitle: Text('Only include that take under 1 hour.',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                      activeColor: Theme.of(context).colorScheme.tertiary,
                      contentPadding:
                          const EdgeInsets.only(left: 34, right: 22),
                    ),
                  ])),
            ),
          ),
        ),
      ),
    );
  }
}
