import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:scrumptious/data/dummy_data.dart';
import 'package:scrumptious/models/meal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrumptious/providers/favourites_provider.dart';
import 'package:scrumptious/data/globals.dart';
import 'package:scrumptious/providers/meals_provider.dart';
import 'package:transparent_image/transparent_image.dart';

class MealDetailsScreen extends ConsumerStatefulWidget {
  const MealDetailsScreen({super.key, required this.mdlMeal});

  final Meal mdlMeal;

  @override
  ConsumerState<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends ConsumerState<MealDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getStepText(String strStep) {
    int intStepNumber = widget.mdlMeal.arrSteps.indexOf(strStep) + 1;
    return '$intStepNumber. $strStep';
  }

  Future<void> _showMultiSelect(BuildContext context, Meal mdlMeal) async {
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

  @override
  Widget build(BuildContext context) {
    final favouriteMeals = ref.watch(favouriteMealsProvider);
    final bIsFavourite = favouriteMeals.contains(widget.mdlMeal);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mdlMeal.strTitle),
        actions: [
          widget.mdlMeal.arrCategories.length == 1 &&
                  widget.mdlMeal.arrCategories[0] == 'c-1'
              ? IconButton(
                  onPressed: () async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    await _showMultiSelect(context, widget.mdlMeal);
                    if (mounted) {
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text("Meal added successfully"),
                        ),
                      );
                    }
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: const Icon(
                      Icons.add,
                      key: ValueKey(true),
                    ),
                  ),
                )
              : IconButton(
                  onPressed: () {
                    final bWasAdded = ref
                        .read(favouriteMealsProvider.notifier)
                        .toggleMealFavouriteStatus(widget.mdlMeal);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(bWasAdded
                          ? "Added meal to favourites!"
                          : "Meal is no longer a favourite!"),
                    ));
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      bIsFavourite ? Icons.star : Icons.star_border,
                      key: ValueKey(bIsFavourite),
                    ),
                  ),
                )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: widget.mdlMeal.strId,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: widget.mdlMeal.arrCategories.contains('c-1')
                    ? NetworkImage(widget.mdlMeal.strImageUrl)
                    : AssetImage(widget.mdlMeal.strImageUrl)
                        as ImageProvider<Object>,
                fit: BoxFit.fitWidth,
                height: 300,
                width: double.infinity,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/placeholder.jpg');
                },
              ),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Ingredients',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 14),
                      for (final ingredient in widget.mdlMeal.arrIngredients)
                        FadeTransition(
                          opacity: animation,
                          child: SizedBox(
                            width: double.infinity,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  ingredient,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'About:',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 14),
                      FadeTransition(
                        opacity: animation,
                        child: getAffordabilityText(widget.mdlMeal).isEmpty
                            ? const SizedBox
                                .shrink() // Render an empty SizedBox if the text is empty
                            : SizedBox(
                                width: double.infinity / 2,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      getAffordabilityText(widget.mdlMeal),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      FadeTransition(
                        opacity: animation,
                        child: getComplexityText(widget.mdlMeal).isEmpty
                            ? const SizedBox
                                .shrink() // Render an empty SizedBox if the text is empty
                            : SizedBox(
                                width: double.infinity,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      getComplexityText(widget.mdlMeal),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      for (var entry in {
                        'Gluten Free': widget.mdlMeal.bIsGlutenFree,
                        'Lactose Free': widget.mdlMeal.bIsLactoseFree,
                        'Vegan': widget.mdlMeal.bIsVegan,
                        'Vegetarian': widget.mdlMeal.bIsVegetarian,
                        'Nut Free': widget.mdlMeal.bIsNutFree,
                        'High Protein': widget.mdlMeal.bIsHighProtein,
                        'Low Calorie': widget.mdlMeal.bIsLowCalorie,
                      }.entries)
                        if (entry.value)
                          FadeTransition(
                            opacity: animation,
                            child: SizedBox(
                              width: double.infinity,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    entry.key,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Steps',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            for (final step in widget.mdlMeal.arrSteps)
              FadeTransition(
                opacity: animation,
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _getStepText(step),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
