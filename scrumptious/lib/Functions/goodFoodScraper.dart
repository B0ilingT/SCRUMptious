import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as htmldom;
import 'dart:convert';
import 'package:scrumptious/models/meal.dart';

Future<List<Meal>> scrapeBBCGoodFood(String searchTerm) async {
  final initialUrl = 'https://www.bbcgoodfood.com/search?q=$searchTerm';
  final List<Meal> meals = [];

  try {
    final response = await http.get(Uri.parse(initialUrl));

    if (response.statusCode == 200) {
      final document = htmlparser.parse(response.body);

      // Find the script tag containing JSON data
      final scriptElement = document.querySelector('#__POST_CONTENT__');

      if (scriptElement != null) {
        final jsonString = scriptElement.text;
        final jsonData = json.decode(jsonString);

        // Find and return the "searchResults" section
        if (jsonData.containsKey('searchResults')) {
          Map<String, dynamic> arrSearchResults = jsonData['searchResults'] as Map<String, dynamic>;
          if (arrSearchResults.containsKey('items')) {
            final List<dynamic> items = arrSearchResults['items'];       
            for (final meal in items) {
              final List<String> arrSteps = [];
              final List<String> ingredients = [];
              int intDuration = 0;
              final List<dynamic> terms = meal['terms'];
              for (final term in terms) {
                if (term['slug'] == 'time') {
                  intDuration = int.parse(term['display']);
                  break; 
                }
              }
              final mealUrl = meal['url'];
              final response = await http.get(Uri.parse(mealUrl));
              if (response.statusCode == 200) {
                final innerDocument = htmlparser.parse(response.body);

                //arrSteps
                final methodStepsElement = innerDocument.querySelector('.recipe__method-steps');
                if (methodStepsElement != null) {
                  final List<htmldom.Element> stepElements = methodStepsElement.querySelectorAll('li');

                  for (final stepElement in stepElements) {
                    final stepNumber = stepElement.querySelector('.heading-6')?.text ?? '';
                    final stepContent = stepElement.querySelector('.editor-content')?.text ?? '';
                    final step = '$stepNumber: $stepContent';
                    arrSteps.add(step);
                  }
                } else {
                  continue;
                }
                //arrIngredients
                final ingredientsElement = innerDocument.querySelector('.recipe__ingredients');
                if (ingredientsElement != null) {
                  final List<htmldom.Element> ingredientElements = ingredientsElement.querySelectorAll('li');

                  for (final ingredientElement in ingredientElements) {
                    final ingredientAnchor = ingredientElement.querySelector('a');
                    
                    if (ingredientAnchor != null) {
                      // If <a> tag exists, extract its text content
                      final ingredient = ingredientAnchor.text.trim();
                      ingredients.add(ingredient);
                    } else {
                      // Otherwise, extract text content of the <li> element
                      final ingredient = ingredientElement.text.trim();
                      ingredients.add(ingredient);
                    }
                  }
                } else {
                  continue;
                }
              } else {

              }
              // meals.add(Meal(
              //   arrCategories: [],
              //   strId: item['id'],
              //   strTitle: item['title'],
              //   strImageUrl: item['image']['url'],
              //   arrIngredients: item['ingredients'],
              //   arrSteps: item['instructions'],
              //   intDuration: item['cookTime'],
              //   enumComplexity: Complexity.simple,
              //   enumAffordability: Affordability.affordable,
              //   bIsGlutenFree: item['isGlutenFree'],
              //   bIsLactoseFree: item['isLactoseFree'],
              //   bIsVegan: item['isVegan'],
              //   bIsVegetarian: item['isVegetarian'],
              
              // ));
            }
          } else {
            print('"items" not found in the search results.');
          }
          for,
        } else {
          print('"searchResults" section not found in the response.');
        }
      } else {
        print(
            'Script tag with id "__POST_CONTENT__" not found in the response.');
      }
    } else {
      print('Failed to load page: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }

  return meals;
}
