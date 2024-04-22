import 'package:flutter/material.dart';
import 'package:scrumptious/data/dummy_data.dart';
import 'package:scrumptious/models/category.dart';
import 'package:scrumptious/models/meal.dart';
import 'package:scrumptious/screens/meals/meals.dart';
import 'package:scrumptious/widgets/categories/category_grid_item.dart';



class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen(
    {
      super.key,
      required this.availableMeals
    }
  );
  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category mdlCategory) {
    final arrFilteredMeals = widget.availableMeals.where(
      (objMeal) => objMeal.arrCategories.contains(mdlCategory.strId)
    ).toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          mdlCategory: mdlCategory, 
          arrMeals: arrFilteredMeals,
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

    return AnimatedBuilder(
      animation: _animationController, 
      child: GridView(
          padding: const EdgeInsets.all(8),
          gridDelegate: grid,
          children: [
            for (final mdlCategory in availableCategories) 
              CategoryGridItem(
                mdlCategory: mdlCategory, 
                onSelectCategory: () {
                  _selectCategory(context, mdlCategory);
                }
              )      
          ],
        ),
      builder: (context, child) => SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.3),
          end: const Offset(0, 0.009)
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack)
        ),
        child: child,
      )
    );
  }
}