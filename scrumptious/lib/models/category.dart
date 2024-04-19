import 'package:flutter/material.dart';

class Category {
  const Category(
    {
      required this.strId,
      required this.strTitle,
      this.colour = Colors.orange
    }
  );
  
  final String strId;
  final String strTitle;
  final Color colour;
}
