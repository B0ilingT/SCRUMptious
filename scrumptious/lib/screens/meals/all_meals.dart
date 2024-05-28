import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scrumptious/data/temp_meals.dart';
import 'package:scrumptious/models/category.dart';
import 'package:scrumptious/models/meal.dart';
import 'package:scrumptious/providers/favourites_provider.dart';
import 'package:scrumptious/screens/meals/meal_details.dart';
import 'package:scrumptious/widgets/meals/meal_item.dart';

class AllMealsScreen extends ConsumerStatefulWidget {
  const AllMealsScreen({
    super.key,
  });

  @override
  ConsumerState<AllMealsScreen> createState() => _AllMealsScreenState();
}

class _AllMealsScreenState extends ConsumerState<AllMealsScreen> {
  @override
  void initState() {
    super.initState();
  }

  void selectMeal(BuildContext context, Meal mdlMeal) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => MealDetailsScreen(
              mdlMeal: mdlMeal,
              addMeal: (Meal meal) {},
            )));
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    const String strTitle = "All Meals";
    const mdlCategory =
        Category(strId: 'c-2', strTitle: "All Meals", colour: Colors.lightBlue);

    final favouriteMeals = ref.watch(favouriteMealsProvider);

    if (tempMeals.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("No meals found!",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            const SizedBox(height: 16),
          ],
        ),
      );
    } else {
      content = ListView.builder(
        itemCount: tempMeals.length,
        itemBuilder: ((context, index) => Slidable(
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: <Widget>[
                  IconTheme(
                    data: const IconThemeData(size: 50),
                    child: SlidableAction(
                      icon: favouriteMeals.contains(tempMeals[index])
                          ? Icons.star
                          : Icons.star_border,
                      onPressed: (context) {
                        final bWasAdded = ref
                            .read(favouriteMealsProvider.notifier)
                            .toggleMealFavouriteStatus(tempMeals[index]);
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
                      icon: Icons.delete,
                      onPressed: (context) {
                        final removedMeal = tempMeals[index];
                        final removedMealIndex = index;
                        removeMeal(tempMeals[index]);
                        setState(() {});
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Meal was deleted"),
                            action: SnackBarAction(
                              label: 'UNDO',
                              onPressed: () {
                                setState(() {
                                  addMealAtIndex(removedMeal, removedMealIndex);
                                });
                              },
                            ),
                          ),
                        );
                      },
                      backgroundColor: const Color.fromARGB(171, 255, 0, 0),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              child: MealItem(
                mdlMeal: tempMeals[index],
                mdlCategory: mdlCategory,
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
            tag: mdlCategory.strId,
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
              onPressed: () async {
                await showSearch(
                    context: context, delegate: MealSearch(tempMeals));
              },
            ),
          ],
        ),
        body: content);
  }
}

class MealSearch extends SearchDelegate<void> {
  final List<Meal> meals;

  MealSearch(this.meals);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white),
      ),
      textTheme: theme.textTheme.copyWith(
        // ignore: deprecated_member_use
        headline6: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = meals.where(
        (meal) => meal.strTitle.toLowerCase().contains(query.toLowerCase()));

    return ListView(
      children: results
          .map((meal) => ListTile(
                title: Text(meal.strTitle),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealDetailsScreen(
                        mdlMeal: meal,
                        addMeal: (Meal meal) {},
                      ),
                    ),
                  );
                },
              ))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = meals.where(
        (meal) => meal.strTitle.toLowerCase().startsWith(query.toLowerCase()));

    return ListView(
      children: suggestions
          .map((meal) => ListTile(
                title: Text(meal.strTitle),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealDetailsScreen(
                        mdlMeal: meal,
                        addMeal: (Meal meal) {},
                      ),
                    ),
                  );
                },
              ))
          .toList(),
    );
  }
}
