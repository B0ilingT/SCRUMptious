import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as htmldom;
import 'package:scrumptious/data/globals.dart';
import 'dart:convert';
import 'package:scrumptious/models/meal.dart';
import 'package:scrumptious/providers/filters_provider.dart';
import 'package:logging/logging.dart';

final _logger = Logger('GoodFoodScraper');

final filterMapping = {
  Filter.vegan: 'vegan',
  Filter.glutenFree: 'gluten-free',
  Filter.lactoseFree: 'dairy-free',
  Filter.vegetarian: 'vegetarian',
  Filter.nutFree: 'nut-free',
  Filter.highProtein: 'high-protein',
  Filter.lowCalorie: 'low-calorie',
  Filter.under30Mins: 'lt-1800',
  Filter.under1Hour: 'lt-3600',
};

List<String> parseIngredients(List<htmldom.Element> arrIngredientElements) {
  final List<String> arrIngredients = [];
  for (final ingredientElement in arrIngredientElements) {
    final ingredientAnchor = ingredientElement.querySelector('a');
    String ingredient;

    if (ingredientAnchor != null) {
      ingredient = ingredientAnchor.text.trim();
    } else {
      ingredient = ingredientElement.text.trim();
    }

    ingredient = ingredient.replaceAll(RegExp(r',\s*$'), '');
    ingredient = ingredient.replaceAll(',', ' -');
    if (ingredient.isNotEmpty) {
      ingredient = capitalizeString(ingredient);
      arrIngredients.add(ingredient);
    }
  }
  return arrIngredients;
}

List<String> parseSteps(List<htmldom.Element> arrStepElements) {
  final List<String> arrSteps = [];
  for (final stepElement in arrStepElements) {
    final stepNumber = stepElement.querySelector('.heading-6')?.text ?? '';
    final stepContent =
        stepElement.querySelector('.editor-content')?.text ?? '';
    final step = '$stepNumber: $stepContent';
    final cleanedStep = step.replaceFirst(RegExp(r'STEP \d+: '), '');
    final steps = cleanedStep.split('.').where((s) => s.trim().isNotEmpty);
    arrSteps.addAll(steps);
  }
  return arrSteps;
}

Complexity mapStringToComplexity(String complexityString) {
  switch (complexityString.toLowerCase()) {
    case 'easy':
      return Complexity.simple;
    case 'more effort':
      return Complexity.challenging;
    case 'a-challenge':
      return Complexity.hard;
    case 'a challenge':
      return Complexity.hard;
    default:
      throw ArgumentError('Invalid complexity string: $complexityString');
  }
}

Future<List<Meal>> scrapeBBCGoodFood(
    String searchTerm, int intResults, bool bIsRandom,
    [Map<Filter, bool> arrFilters = const {}]) async {
  if (arrFilters.isNotEmpty) {
    final List<String> arrFilterStrings = [];
    String strDuration = '';
    for (final filter in arrFilters.entries) {
      if (filter.key == Filter.under1Hour &&
          filter.value &&
          strDuration == '') {
        strDuration = "&totalTime=${filterMapping[filter.key]}";
        continue;
      }
      if (filter.key == Filter.under30Mins && filter.value) {
        strDuration = "&totalTime=${filterMapping[filter.key]}";
        continue;
      }
      if (filter.value) {
        arrFilterStrings.add(filterMapping[filter.key]!);
      }
    }
    if (arrFilterStrings.isNotEmpty) {
      searchTerm += '&diet=${arrFilterStrings.join('%2C')}';
    }
    if (strDuration.isNotEmpty) {
      searchTerm += strDuration;
    }
  }
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
            if (bIsRandom) {
              items.shuffle();
            }
            for (final meal in items) {
              List<String> arrSteps = [];
              List<String> arrIngredients = [];
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
                  arrSteps =
                      parseSteps(methodStepsElement.querySelectorAll('li'));
                } else {
                  continue;
                }
                //arrIngredients
                final ingredientsElement =
                    innerDocument.querySelector('.recipe__ingredients');
                if (ingredientsElement != null) {
                  arrIngredients = parseIngredients(
                      ingredientsElement.querySelectorAll('li'));
                } else {
                  continue;
                }
                if (meals.length > intResults) {
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
      _logger.warning('Failed to load page: ${response.statusCode}');
    }
  } catch (e, s) {
    _logger.severe('Exception: $e', e, s);
  }
  return meals;
}
