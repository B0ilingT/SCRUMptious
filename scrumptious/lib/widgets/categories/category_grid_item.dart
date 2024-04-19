import 'package:flutter/material.dart';
import 'package:scrumptious/models/category.dart';

class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem(
    {
      super.key, 
      required this.mdlCategory,
      required this.onSelectCategory
    }
  );

  final Category mdlCategory;
  final void Function() onSelectCategory;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelectCategory,
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              mdlCategory.colour.withOpacity(0.55),
              mdlCategory.colour.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(
          mdlCategory.strTitle,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        )
      ),
    );
  }
}
