import 'package:flutter/material.dart';
import 'package:scrumptious/data/dummy_data.dart';
import 'package:scrumptious/screens/meals/meals.dart';
import 'package:scrumptious/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  void _selectCategory(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const MealsScreen(
          strTitle: "Some title", 
          arrMeals: []
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    // Layout control:
    SliverGridDelegateWithFixedCrossAxisCount grid =  const SliverGridDelegateWithFixedCrossAxisCount( 
      crossAxisCount: 2,
      childAspectRatio: 3 / 2,
      crossAxisSpacing: 20,
      mainAxisSpacing:  20,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick a "SCRUM"ptious Category'),
      ),
      body: GridView(
        padding: const EdgeInsets.all(8),
        gridDelegate: grid,
        children: [
          for (final mdlCategory in availableCategories) 
            CategoryGridItem(
              mdlCategory: mdlCategory, 
              onSelectCategory: () {
                _selectCategory(context);
              }
            )      
        ],
      )
    );
  }
}