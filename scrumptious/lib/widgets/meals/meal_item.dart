import 'package:flutter/material.dart';
import 'package:scrumptious/models/category.dart';
import 'package:scrumptious/models/meal.dart';
import 'package:scrumptious/widgets/meals/meal_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class MealItem extends StatelessWidget {
  const MealItem(
    {
      super.key,
      required this.mdlMeal,
      required this.mdlCategory,
      required this.onSelectMeal
    }
  );

  final Meal mdlMeal;
  final Category mdlCategory;
  final void Function(Meal mdlMeal) onSelectMeal;

  String get complexityText {
    String strName = mdlMeal.enumComplexity.name;
    return '${strName[0].toUpperCase()}${strName.substring(1)}';
  }

  String get affordabilityText {
    switch (mdlMeal.enumAffordability) {
      case Affordability.affordable:
        return '£';
      case Affordability.pricey:
        return '££';
      case Affordability.luxurious:
        return '£££';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      surfaceTintColor: mdlCategory.colour,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {
          onSelectMeal(mdlMeal);
        },
        child: Stack(
          children: [
            Hero(
              tag: mdlMeal.strId,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage), 
                image: NetworkImage(mdlMeal.strImageUrl),
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: mdlCategory.colour.withOpacity(0.75),
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 44),
                child: Column(
                  children: [
                    Text(
                      mdlMeal.strTitle,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MealItemTrait(
                          icon: Icons.schedule, 
                          strLabel: '${mdlMeal.intDuration.toString()}m'
                        ),
                        const SizedBox(width: 12),
                        MealItemTrait(
                          icon: Icons.assessment_outlined, 
                          strLabel: complexityText
                        ),
                        const SizedBox(width: 12),
                        MealItemTrait(
                          icon: Icons.remove, 
                          strLabel: affordabilityText
                        ),
                      ],
                    )
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}