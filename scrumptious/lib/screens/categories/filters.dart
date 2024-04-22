import 'package:flutter/material.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan
}

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() {
    return _FiltersScreenState();
  }
}

class _FiltersScreenState extends State<FiltersScreen> {
  var _bGlutenFreeFilterSet = false;
  var _bLactoseFreeFilterSet = false;
  var _bVegetarianFilterSet = false;
  var _bVeganFilterSet = false;

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
          Navigator.of(context).pop({
            Filter.glutenFree: _bGlutenFreeFilterSet,
            Filter.lactoseFree: _bLactoseFreeFilterSet,
            Filter.vegetarian: _bVegetarianFilterSet,
            Filter.vegan: _bVeganFilterSet,
          });
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