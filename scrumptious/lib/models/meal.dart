enum Complexity {
  simple,
  challenging,
  hard,
}

Complexity stringToComplexity(String str) {
  return Complexity.values
      .firstWhere((e) => e.toString() == str, orElse: () => Complexity.simple);
}

enum Affordability {
  affordable,
  pricey,
  luxurious,
}

Affordability stringToAffordability(String str) {
  return Affordability.values.firstWhere((e) => e.toString() == str,
      orElse: () => Affordability.affordable);
}

class Meal {
  const Meal({
    required this.strId,
    required this.arrCategories,
    required this.strTitle,
    required this.strImageUrl,
    required this.arrIngredients,
    required this.arrSteps,
    required this.intDuration,
    required this.enumComplexity,
    required this.enumAffordability,
    required this.bIsGlutenFree,
    required this.bIsLactoseFree,
    required this.bIsVegan,
    required this.bIsVegetarian,
  });

  final String strId;
  final List<String> arrCategories;
  final String strTitle;
  final String strImageUrl;
  final List<String> arrIngredients;
  final List<String> arrSteps;
  final int intDuration;
  final Complexity enumComplexity;
  final Affordability enumAffordability;
  final bool bIsGlutenFree;
  final bool bIsLactoseFree;
  final bool bIsVegan;
  final bool bIsVegetarian;

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      strId: json['strId'],
      arrCategories:
          json['arrCategories'].map<String>((item) => item.toString()).toList(),
      strTitle: json['strTitle'],
      strImageUrl: json['strImageUrl'],
      arrIngredients: json['arrIngredients']
          .map<String>((item) => item.toString())
          .toList(),
      arrSteps:
          json['arrSteps'].map<String>((item) => item.toString()).toList(),
      intDuration: json['intDuration'],
      enumComplexity: stringToComplexity(json['enumComplexity']),
      enumAffordability: stringToAffordability(json['enumAffordability']),
      bIsGlutenFree: json['bIsGlutenFree'],
      bIsLactoseFree: json['bIsLactoseFree'],
      bIsVegan: json['bIsVegan'],
      bIsVegetarian: json['bIsVegetarian'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'strId': strId,
      'arrCategories': arrCategories,
      'strTitle': strTitle,
      'strImageUrl': strImageUrl,
      'arrIngredients': arrIngredients,
      'arrSteps': arrSteps,
      'intDuration': intDuration,
      'enumComplexity': enumComplexity.toString(),
      'enumAffordability': enumAffordability.toString(),
      'bIsGlutenFree': bIsGlutenFree,
      'bIsLactoseFree': bIsLactoseFree,
      'bIsVegan': bIsVegan,
      'bIsVegetarian': bIsVegetarian
    };
  }
}
