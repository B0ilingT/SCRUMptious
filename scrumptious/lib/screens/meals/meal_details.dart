import 'package:flutter/material.dart';
import 'package:scrumptious/models/meal.dart';

class MealDetailsScreen extends StatelessWidget{
  const MealDetailsScreen(
    {
      super.key,
      required this.mdlMeal,
    }
  );

  final Meal mdlMeal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mdlMeal.strTitle)
      ),
      body: Image.network(
        mdlMeal.strImageUrl,
        height: 300,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}