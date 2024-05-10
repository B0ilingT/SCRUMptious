import 'package:flutter/material.dart';
import 'package:scrumptious/Functions/good_food_scraper.dart';
import 'package:scrumptious/screens/meals/meals.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Future<void>? _searchFuture;
  final _titleController = TextEditingController();

  Category searchResults = const Category(
      strId: 'c-1',
      strTitle: 'Results',
      colour: Color.fromARGB(255, 140, 0, 255));

  Future _submitMealData() async {
    final arrFilteredMeals = await scrapeBBCGoodFood(_titleController.text);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => MealsScreen(
              mdlCategory: searchResults,
              arrMeals: arrFilteredMeals,
            )));
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final activeFilters = ref.watch(filtersProvider);
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
                        label: Text("Title:",
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
                            Navigator.pop(context);
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
                        ref
                            .read(filtersProvider.notifier)
                            .setFilter(Filter.glutenFree, bIsChecked);
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
                        ref
                            .read(filtersProvider.notifier)
                            .setFilter(Filter.lactoseFree, bIsChecked);
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
                      value: activeFilters[Filter.vegetarian]!,
                      onChanged: (bIsChecked) {
                        ref
                            .read(filtersProvider.notifier)
                            .setFilter(Filter.vegetarian, bIsChecked);
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
                        ref
                            .read(filtersProvider.notifier)
                            .setFilter(Filter.vegan, bIsChecked);
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
                  ])),
            ),
          ),
        ),
      ),
    );
  }
}
