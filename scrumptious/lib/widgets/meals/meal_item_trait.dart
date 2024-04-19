import 'package:flutter/material.dart';

class MealItemTrait extends StatelessWidget{
  const MealItemTrait(
    {
      super.key,
      required this.icon,
      required this.strLabel
    }
  );

  final IconData icon;
  final String strLabel;

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (icon == Icons.remove) {
      content = Row(
        children: [
          Text(
            strLabel,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      );
    } else {
      content = Row(
        children: [
          Icon(
            icon,
            size: 17,
            color: Colors.white,
          ),
          const SizedBox(width: 1),
          Text(
            strLabel,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      );
    }
    return content;
  }
}