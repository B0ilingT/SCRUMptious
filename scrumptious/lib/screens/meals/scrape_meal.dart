import 'package:flutter/material.dart';
import 'package:scrumptious/Functions/good_food_scraper.dart';
import 'package:scrumptious/providers/filters_provider.dart';
import 'package:scrumptious/screens/meals/meals.dart';
import 'package:scrumptious/screens/shared/tabs.dart';
import 'package:uuid/uuid.dart';
import 'package:scrumptious/models/category.dart';
import 'package:scrumptious/models/meal.dart';

var uuid = const Uuid();

class ScrapeMeal extends StatefulWidget {
  const ScrapeMeal({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ScrapeMealState();
  }
}

class _ScrapeMealState extends State<ScrapeMeal>
    with SingleTickerProviderStateMixin {
  bool showFilters = false;
  List<Meal> _arrMeals = [];
  Future<void>? _searchFuture;
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

  final _titleController = TextEditingController();
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onTitleChanged);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve:
          const Cubic(0.68, -0.15, 0.27, 1.2), // Last number is bounce height
    ));
  }

  Category searchResults = const Category(
      strId: 'c-1',
      strTitle: 'Results',
      colour: Color.fromARGB(255, 140, 0, 255));

  Future _submitMealData() async {
    List<Meal> newMeals = await scrapeBBCGoodFood(
        _titleController.text, 15, false, activeFilters);
    _arrMeals.insertAll(0, newMeals);

    _arrMeals = _arrMeals
        .map((meal) => meal.strTitle)
        .toSet()
        .map((title) => _arrMeals.firstWhere((meal) => meal.strTitle == title))
        .toList();

    if (mounted) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => MealsScreen(
                mdlCategory: searchResults,
                arrMeals: _arrMeals,
              )));
    }
  }

  void _onTitleChanged() async {
    if (_titleController.text.length > 3) {
      List<Meal> newMeals = await scrapeBBCGoodFood(
          _titleController.text, 5, true, activeFilters);
      _arrMeals.addAll(newMeals);
    }
  }

  void updateFilter(Filter filterType, bool newValue) {
    setState(() {
      activeFilters[filterType] = newValue;
    });
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _titleController.dispose();
    _controller.dispose();
    _arrMeals = [];
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
            physics: showFilters
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
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
                      decoration: InputDecoration(
                        label: const Text("Search:",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        helperStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        suffixIcon: Transform.scale(
                          scale:
                              0.7, // Adjust this value to make the button smaller or larger
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _arrMeals.clear();
                                _titleController.clear();
                              });
                            },
                          ),
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
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () {
                          setState(() {
                            showFilters = !showFilters;
                          });
                          if (showFilters) {
                            _controller.forward();
                          } else {
                            _controller.reverse();
                          }
                        },
                      )
                    ]),
                    SlideTransition(
                        position: _offsetAnimation,
                        child: ClipRect(
                          child: Column(children: [
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
                              activeColor:
                                  Theme.of(context).colorScheme.tertiary,
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
                              activeColor:
                                  Theme.of(context).colorScheme.tertiary,
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
                              activeColor:
                                  Theme.of(context).colorScheme.tertiary,
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
                              subtitle: Text(
                                  'Only include vegetarian friendly meals.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground)),
                              activeColor:
                                  Theme.of(context).colorScheme.tertiary,
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
                              subtitle: Text(
                                  'Only include vegan friendly meals.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground)),
                              activeColor:
                                  Theme.of(context).colorScheme.tertiary,
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
                              activeColor:
                                  Theme.of(context).colorScheme.tertiary,
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
                              activeColor:
                                  Theme.of(context).colorScheme.tertiary,
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
                              subtitle: Text(
                                  'Only include that take under 30 minutes.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground)),
                              activeColor:
                                  Theme.of(context).colorScheme.tertiary,
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
                              subtitle: Text(
                                  'Only include that take under 1 hour.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground)),
                              activeColor:
                                  Theme.of(context).colorScheme.tertiary,
                              contentPadding:
                                  const EdgeInsets.only(left: 34, right: 22),
                            ),
                          ]),
                        )),
                  ])),
            ),
          ),
        ),
      ),
    );
  }
}
