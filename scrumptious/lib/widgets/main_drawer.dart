import 'package:flutter/material.dart';
import 'package:scrumptious/data/globals.dart' as globals;

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onTapDrawerTile});

  final void Function(String strIdentifier) onTapDrawerTile;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
            child: Row(children: [
              Icon(Icons.fastfood,
                  size: 48, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 18),
              Text(
                "Test",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary, fontSize: 36),
              ),
            ])),
        ListTile(
          leading: Icon(
            Icons.restaurant,
            size: 26,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          title: Text(
            globals.strMealsTitle,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 24),
          ),
          onTap: () {
            onTapDrawerTile(globals.strMealsTitle);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.filter_list,
            size: 26,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          title: Text(
            globals.strFiltersTitle,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 24),
          ),
          onTap: () {
            onTapDrawerTile(globals.strFiltersTitle);
          },
        ),
      ],
    ));
  }
}
