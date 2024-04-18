import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

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
        title: const Text("Pick your SCRUMptious Category"),
      ),
      body: GridView(
        gridDelegate: grid
        children: [],
      )
    );
  }
}