enum Complexity {
  simple,
  challenging,
  hard,
}

enum Affordability {
  affordable,
  pricey,
  luxurious,
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
      arrCategories: json['arrCategories'],
      strTitle: json['strTitle'],
      strImageUrl: json['strImageUrl'],
      arrIngredients: json['arrIngredients'],
      arrSteps: json['arrSteps'],
      intDuration: json['intDuration'],
      enumComplexity: json['enumComplexity'],
      enumAffordability: json['enumAffordability'],
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
      'enumComplexity': enumComplexity,
      'enumAffordability': enumAffordability,
      'bIsGlutenFree': bIsGlutenFree,
      'bIsLactoseFree': bIsLactoseFree,
      'bIsVegan': bIsVegan,
      'bIsVegetarian': bIsVegetarian
    };
  }
}
