import 'package:flutter/material.dart';
import 'package:scrumptious/models/category.dart';
import 'package:scrumptious/screens/categories/categories.dart';
import 'package:scrumptious/screens/categories/filters.dart';
import 'package:scrumptious/screens/meals/meals.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrumptious/providers/meals_provider.dart';
import 'package:scrumptious/providers/favourites_provider.dart';
import 'package:scrumptious/providers/filters_provider.dart';
import 'package:scrumptious/data/globals.dart' as globals;

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _intSelectedPageIndex = 0;

  Category favourites = const Category(
    strId: 'c0', 
    strTitle: 'Favorites', 
    colour: Color.fromARGB(255, 255, 187, 0)
  );

  void _selectPage(int index) {
    setState(() {
      _intSelectedPageIndex = index;
    });
  }

  void _setScreen(String strIdentifier) async {
    Navigator.of(context).pop();
    switch (strIdentifier) {
      case globals.strFiltersTitle:
        await Navigator.of(context).push<Map<Filter, bool>>(
          MaterialPageRoute(
            builder: (ctx) => const FiltersScreen()
          )
        );
        break;
      case globals.strMealsTitle:
        break;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final arrMeals = ref.watch(mealsProvider);
    final activeFilters = ref.watch(filtersProvider);
    final availableMeals = arrMeals.where((meal) {
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
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      onSetScreen: _setScreen,
      availableMeals: availableMeals,
    );

    if (_intSelectedPageIndex == 1) {
      final arrFavouriteMeals = ref.watch(favouriteMealsProvider);
      activePage = MealsScreen(
        arrMeals: arrFavouriteMeals, 
        mdlCategory: favourites, 
      );
    }

    return Scaffold(
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _intSelectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favourites',
          ),
        ],
      ),
    );
  }
}