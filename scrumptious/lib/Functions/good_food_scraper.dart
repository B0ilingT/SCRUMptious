import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as htmldom;
import 'dart:convert';
import 'package:scrumptious/models/meal.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

Future<List<Meal>> scrapeBBCGoodFood(String searchTerm,
    [List<String> arrFilters = const []]) async {
  final initialUrl = 'https://www.bbcgoodfood.com/search?q=$searchTerm';
  final List<Meal> meals = [];

  try {
    final response = await http.get(Uri.parse(initialUrl));

    if (response.statusCode == 200) {
      final document = htmlparser.parse(response.body);

      final scriptElement = document.querySelector('#__POST_CONTENT__');

      if (scriptElement != null) {
        final jsonString = scriptElement.text;
        final jsonData = json.decode(jsonString);

        if (jsonData.containsKey('searchResults')) {
          Map<String, dynamic> arrSearchResults =
              jsonData['searchResults'] as Map<String, dynamic>;
          if (arrSearchResults.containsKey('items')) {
            final List<dynamic> items = arrSearchResults['items'];
            for (final meal in items) {
              final List<String> arrSteps = [];
              final List<String> arrIngredients = [];
              int intDuration = 0;
              Complexity enumComplexity = Complexity.simple;
              bool bIsGlutenFree = false;
              bool bIsLactoseFree = false;
              bool bIsVegan = false;
              bool bIsVegetarian = false;

              final List<dynamic> terms = meal['terms'];
              for (final term in terms) {
                if (term['slug'] == 'time') {
                  String strDuration = term['display'];
                  int spaceIndex = strDuration.indexOf(' ');
                  if (spaceIndex != -1) {
                    strDuration = strDuration.substring(0, spaceIndex);
                    intDuration = int.parse(strDuration);
                  } else {
                    intDuration = int.parse(strDuration);
                  }
                }
                if (term['slug'] == 'skillLevel') {
                  enumComplexity = mapStringToComplexity(term['display']);
                }
                if (term['slug'] == 'vegetarian') {
                  bIsVegetarian = true;
                }
                if (term['slug'] == 'gluten-free') {
                  bIsGlutenFree = true;
                }
                if (term['slug'] == 'vegan') {
                  bIsGlutenFree = true;
                }
                if (term['slug'] == 'dairy-free') {
                  bIsGlutenFree = true;
                }
              }
              final mealUrl = 'https://www.bbcgoodfood.com/${meal['url']}';
              final response = await http.get(Uri.parse(mealUrl));
              if (response.statusCode == 200) {
                final innerDocument = htmlparser.parse(response.body);

                //arrSteps
                final methodStepsElement =
                    innerDocument.querySelector('.recipe__method-steps');
                if (methodStepsElement != null) {
                  final List<htmldom.Element> stepElements =
                      methodStepsElement.querySelectorAll('li');

                  for (final stepElement in stepElements) {
                    final stepNumber =
                        stepElement.querySelector('.heading-6')?.text ?? '';
                    final stepContent =
                        stepElement.querySelector('.editor-content')?.text ??
                            '';
                    final step = '$stepNumber: $stepContent';
                    final cleanedStep =
                        step.replaceFirst(RegExp(r'STEP \d+: '), '');
                    final steps = cleanedStep
                        .split('.')
                        .where((s) => s.trim().isNotEmpty);
                    arrSteps.addAll(steps);
                  }
                } else {
                  continue;
                }
                //arrIngredients
                final ingredientsElement =
                    innerDocument.querySelector('.recipe__ingredients');
                if (ingredientsElement != null) {
                  final List<htmldom.Element> ingredientElements =
                      ingredientsElement.querySelectorAll('li');

                  for (final ingredientElement in ingredientElements) {
                    final ingredientAnchor =
                        ingredientElement.querySelector('a');
                    String ingredient;

                    if (ingredientAnchor != null) {
                      ingredient = ingredientAnchor.text.trim();
                    } else {
                      ingredient = ingredientElement.text.trim();
                    }

                    ingredient = ingredient.replaceAll(RegExp(r',\s*$'), '');
                    ingredient = ingredient.replaceAll(',', ' -');
                    ingredient = capitalize(ingredient);

                    arrIngredients.add(ingredient);
                  }
                } else {
                  continue;
                }
                if (meals.length > 30) {
                  break;
                }
                meals.add(Meal(
                  arrCategories: ['c-1'],
                  strId: meal['id'],
                  strTitle: meal['title'],
                  strImageUrl: meal['image']['url'],
                  arrIngredients: arrIngredients,
                  arrSteps: arrSteps,
                  intDuration: intDuration,
                  enumComplexity: enumComplexity,
                  enumAffordability: Affordability.affordable,
                  bIsGlutenFree: bIsGlutenFree,
                  bIsLactoseFree: bIsLactoseFree,
                  bIsVegan: bIsVegan,
                  bIsVegetarian: bIsVegetarian,
                ));
              } else {}
            }
          }
        }
      }
    } else {
      //print('Failed to load page: ${response.statusCode}');
    }
  } catch (e) {
    print(e.toString());
  }
  return meals;
}

Complexity mapStringToComplexity(String complexityString) {
  switch (complexityString.toLowerCase()) {
    case 'easy':
      return Complexity.simple;
    case 'more effort':
      return Complexity.challenging;
    case 'a-challenge':
      return Complexity.hard;
    default:
      throw ArgumentError('Invalid complexity string: $complexityString');
  }
}
