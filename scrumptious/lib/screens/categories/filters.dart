import 'package:flutter/material.dart';
import 'package:scrumptious/providers/filters_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FiltersScreen extends ConsumerStatefulWidget {
  const FiltersScreen({super.key});

  @override
  ConsumerState<FiltersScreen> createState() {
    return _FiltersScreenState();
  }
}

class _FiltersScreenState extends ConsumerState<FiltersScreen> {
  var _bGlutenFreeFilterSet = false;
  var _bLactoseFreeFilterSet = false;
  var _bVegetarianFilterSet = false;
  var _bVeganFilterSet = false;

  @override
  void initState() {
    super.initState();
    final activeFilters = ref.read(filtersProvider);
    _bGlutenFreeFilterSet = activeFilters[Filter.glutenFree]!;
    _bLactoseFreeFilterSet = activeFilters[Filter.lactoseFree]!;
    _bVegetarianFilterSet = activeFilters[Filter.vegetarian]!;
    _bVeganFilterSet = activeFilters[Filter.vegan]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Filters'),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if(didPop) return;
          ref.read(filtersProvider.notifier).setFilters({
            Filter.glutenFree: _bGlutenFreeFilterSet,
            Filter.lactoseFree: _bLactoseFreeFilterSet,
            Filter.vegetarian: _bVegetarianFilterSet,
            Filter.vegan: _bVeganFilterSet,
          });
          Navigator.of(context).pop();
        },
        child: Column(
          children: [
            SwitchListTile(
              value: _bGlutenFreeFilterSet, 
              onChanged: (bIsChecked) {
                setState(() {
                  _bGlutenFreeFilterSet = bIsChecked;
                });
              },
              title: Text(
                'Gluten-free', 
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground
                )
              ),
              subtitle: Text(
                'Only include gluten-free meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground
                )
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: _bLactoseFreeFilterSet, 
              onChanged: (bIsChecked) {
                setState(() {
                  _bLactoseFreeFilterSet = bIsChecked;
                });
              },
              title: Text(
                'Lactose-free', 
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground
                )
              ),
              subtitle: Text(
                'Only include lactose-free meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground
                )
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: _bVegetarianFilterSet, 
              onChanged: (bIsChecked) {
                setState(() {
                  _bVegetarianFilterSet = bIsChecked;
                });
              },
              title: Text(
                'Vegetarian', 
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground
                )
              ),
              subtitle: Text(
                'Only include vegetarian friendly meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground
                )
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: _bVeganFilterSet, 
              onChanged: (bIsChecked) {
                setState(() {
                  _bVeganFilterSet = bIsChecked;
                });
              },
              title: Text(
                'Vegan', 
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground
                )
              ),
              subtitle: Text(
                'Only include vegan friendly meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground
                )
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
          ],
        ),
      )
    );
  }
}