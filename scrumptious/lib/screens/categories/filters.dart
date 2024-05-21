import 'package:flutter/material.dart';
import 'package:scrumptious/providers/filters_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FiltersScreen extends ConsumerWidget {
  const FiltersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters = ref.watch(filtersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Filters'),
      ),
      body: Column(
        children: [
          SwitchListTile(
            value: activeFilters[Filter.glutenFree]!,
            onChanged: (bIsChecked) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.glutenFree, bIsChecked);
            },
            title: Text('Gluten-free',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            subtitle: Text('Only include gluten-free meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ),
          SwitchListTile(
            value: activeFilters[Filter.lactoseFree]!,
            onChanged: (bIsChecked) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.lactoseFree, bIsChecked);
            },
            title: Text('Lactose-free',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            subtitle: Text('Only include lactose-free meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ),
          SwitchListTile(
            value: activeFilters[Filter.nutFree]!,
            onChanged: (bIsChecked) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.nutFree, bIsChecked);
            },
            title: Text('Nut-free',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            subtitle: Text('Only include nut-free meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ),
          SwitchListTile(
            value: activeFilters[Filter.vegetarian]!,
            onChanged: (bIsChecked) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.vegetarian, bIsChecked);
            },
            title: Text('Vegetarian',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            subtitle: Text('Only include vegetarian friendly meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ),
          SwitchListTile(
            value: activeFilters[Filter.vegan]!,
            onChanged: (bIsChecked) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.vegan, bIsChecked);
            },
            title: Text('Vegan',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            subtitle: Text('Only include vegan friendly meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ),
          SwitchListTile(
            value: activeFilters[Filter.highProtein]!,
            onChanged: (bIsChecked) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.highProtein, bIsChecked);
            },
            title: Text('High Protein',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            subtitle: Text('Only include high protein meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ),
          SwitchListTile(
            value: activeFilters[Filter.lowCalorie]!,
            onChanged: (bIsChecked) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.lowCalorie, bIsChecked);
            },
            title: Text('Low Calorie',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            subtitle: Text('Only include low calorie meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ),
          SwitchListTile(
            value: activeFilters[Filter.under30Mins]!,
            onChanged: (bIsChecked) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.under30Mins, bIsChecked);
            },
            title: Text('< 30 mins',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            subtitle: Text('Only include that take under 30 minutes.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ),
          SwitchListTile(
            value: activeFilters[Filter.under1Hour]!,
            onChanged: (bIsChecked) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.under1Hour, bIsChecked);
            },
            title: Text('< 1 hour',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            subtitle: Text('Only include that take under 1 hour.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ),
        ],
      ),
    );
  }
}
