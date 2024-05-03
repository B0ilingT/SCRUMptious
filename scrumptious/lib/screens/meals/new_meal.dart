import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:scrumptious/models/category.dart';
import 'package:scrumptious/models/meal.dart';

var uuid = const Uuid();

class NewMeal extends StatefulWidget {
  const NewMeal({super.key, required this.onAddMeal});

  final void Function(Meal meal) onAddMeal;

  @override
  State<StatefulWidget> createState() {
    return _NewMealState();
  }
}

class _NewMealState extends State<NewMeal> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final _titleController = TextEditingController();
  final strImageUrl = "";
  final List<String> arrCategories = [];
  final List<String> arrIngredients = [];
  final List<String> arrSteps = [];
  final int intDuration = 0;
  Complexity _selectedComplexity = Complexity.simple;
  Affordability _selectedAffordability = Affordability.affordable;
  final bool bIsGlutenFree = false;
  final bool bIsLactoseFree = false;
  final bool bIsVegan = false;
  final bool bIsVegetarian = false;

  void _submitMealData() {
    widget.onAddMeal(Meal(
        strId: uuid.v4(),
        arrCategories: arrCategories,
        strTitle: _titleController.text,
        strImageUrl: strImageUrl,
        arrIngredients: arrIngredients,
        arrSteps: arrSteps,
        intDuration: intDuration,
        enumComplexity: _selectedComplexity,
        enumAffordability: _selectedAffordability,
        bIsGlutenFree: bIsGlutenFree,
        bIsLactoseFree: bIsLactoseFree,
        bIsVegan: bIsVegan,
        bIsVegetarian: bIsVegetarian));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: double.infinity,
      child: Container(
        color: Theme.of(context).colorScheme.background,
        width: double.infinity,
        child: SingleChildScrollView(
          clipBehavior: Clip.hardEdge,
          child: Container(
            width: width,
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.background),
            child: Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, keyboardSpace + 16),
                child: Column(children: [
                  TextField(
                    controller: _titleController,
                    enableSuggestions: true,
                    maxLength: 50,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      label: Text("Title:",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      helperStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(children: [
                    DropdownButton(
                        style: Theme.of(context).textTheme.labelMedium,
                        value: _selectedComplexity,
                        items: Complexity.values
                            .map((catergory) => DropdownMenuItem(
                                value: catergory,
                                child: Text(
                                  catergory.name.toString().toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                )))
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedComplexity = value;
                          });
                        }),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                    ElevatedButton(
                      onPressed: () {
                        _submitMealData();
                      },
                      child: const Text(
                        'Save Meal',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ]),
                  DropdownButton(
                      style: Theme.of(context).textTheme.labelMedium,
                      value: _selectedAffordability,
                      items: Affordability.values
                          .map((affordability) => DropdownMenuItem(
                              value: affordability,
                              child: Text(
                                affordability.name.toString().toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              )))
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedAffordability = value;
                        });
                      }),
                ])),
          ),
        ),
      ),
    );
  }
}
