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
    this.bIsGlutenFree = false,
    this.bIsLactoseFree = false,
    this.bIsVegan = false,
    this.bIsVegetarian = false,
    this.bIsNutFree = false,
    this.bIsHighProtein = false,
    this.bIsLowCalorie = false,
    bool? bIsUnder30Mins = false,
    bool? bIsUnder1Hour = false,
  })  : bIsUnder30Mins = bIsUnder30Mins ?? intDuration < 30,
        bIsUnder1Hour = bIsUnder1Hour ?? intDuration < 60;

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
  final bool bIsNutFree;
  final bool bIsHighProtein;
  final bool bIsLowCalorie;
  final bool bIsUnder30Mins;
  final bool bIsUnder1Hour;

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
      bIsNutFree: json['bIsNutFree'],
      bIsHighProtein: json['bIsHighProtein'],
      bIsLowCalorie: json['bIsLowCalorie'],
      bIsUnder30Mins: json['bIsUnder30Mins'],
      bIsUnder1Hour: json['bIsUnder1Hour'],
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
      'bIsVegetarian': bIsVegetarian,
      'bIsNutFree': bIsNutFree,
      'bIsHighProtein': bIsHighProtein,
      'bIsLowCalorie': bIsLowCalorie,
      'bIsUnder30Mins': bIsUnder30Mins,
      'bIsUnder1Hour': bIsUnder1Hour
    };
  }
}
