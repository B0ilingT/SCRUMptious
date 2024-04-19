import 'package:flutter/material.dart';
import 'package:scrumptious/models/category.dart';
import 'package:scrumptious/screens/categories/categories.dart';
import 'package:scrumptious/screens/meals/meals.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
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



  @override
  Widget build(BuildContext context) {
    Widget activePage = const CategoriesScreen();

    if (_intSelectedPageIndex == 1) {
      activePage = MealsScreen(arrMeals: [], mdlCategory: favourites);
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