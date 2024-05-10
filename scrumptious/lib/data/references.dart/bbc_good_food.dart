const filters = [
  {
    "label": "Meal type",
    "name": "mealType",
    "defaultValues": [],
    "options": [
      {"value": "afternoon-tea", "label": "Afternoon tea", "count": 7},
      {"value": "breads", "label": "Breads", "count": 1},
      {"value": "breakfast", "label": "Breakfast", "count": 1},
      {"value": "buffet", "label": "Buffet", "count": 21},
      {"value": "canapes", "label": "Canapes", "count": 5},
      {"value": "condiment", "label": "Condiment", "count": 7},
      {"value": "dessert", "label": "Dessert", "count": 13},
      {"value": "dinner", "label": "Dinner", "count": 126},
      {"value": "lunch", "label": "Lunch", "count": 92},
      {"value": "main-course", "label": "Main course", "count": 132},
      {"value": "pasta", "label": "Pasta", "count": 1},
      {"value": "side-dish", "label": "Side dish", "count": 21},
      {"value": "snack", "label": "Snack", "count": 50},
      {"value": "starter", "label": "Starter", "count": 13},
      {"value": "supper", "label": "Supper", "count": 66},
      {"value": "treat", "label": "Treat", "count": 9},
      {"value": "vegetable", "label": "Vegetable", "count": 2}
    ]
  },
  {
    "label": "Total time",
    "name": "totalTime",
    "type": "radio",
    "defaultValues": [],
    "options": [
      {"value": "lt-900", "label": "Under 15 minutes", "count": 13},
      {"value": "lt-1800", "label": "Under 30 minutes", "count": 60},
      {"value": "lt-2700", "label": "Under 45 minutes", "count": 118},
      {"value": "lt-3600", "label": "Under 1 hour", "count": 170},
      {"value": "gte-3600", "label": "1 hour or more", "count": 65}
    ]
  },
  {
    "label": "Diets",
    "name": "diet",
    "defaultValues": [],
    "options": [
      {"value": "vegetarian", "label": "Vegetarian", "count": 108},
      {"value": "healthy", "label": "Healthy", "count": 16},
      {"value": "vegan", "label": "Vegan", "count": 14},
      {"value": "gluten-free", "label": "Gluten-free", "count": 13},
      {"value": "egg-free", "label": "Egg-free", "count": 10},
      {"value": "nut-free", "label": "Nut-free", "count": 7},
      {"value": "dairy-free", "label": "Dairy-free", "count": 6},
      {"value": "low-sugar", "label": "Low sugar", "count": 4},
      {"value": "high-fibre", "label": "High-fibre", "count": 1},
      {"value": "high-protein", "label": "High-protein", "count": 1},
      {"value": "low-calorie", "label": "Low calorie", "count": 1},
      {"value": "low-fat", "label": "Low fat", "count": 1}
    ]
  },
  {
    "label": "Difficulty",
    "name": "difficulty",
    "defaultValues": [],
    "options": [
      {"value": "easy", "label": "Easy", "count": 202},
      {"value": "more-effort", "label": "More effort", "count": 25},
      {"value": "a-challenge", "label": "A challenge", "count": 6}
    ]
  },
  {
    "label": "Cuisine",
    "name": "cuisine",
    "defaultValues": [],
    "options": [
      {"value": "american", "label": "American", "count": 4},
      {"value": "british", "label": "British", "count": 18},
      {"value": "cajun-creole", "label": "Cajun & Creole", "count": 1},
      {"value": "chinese", "label": "Chinese", "count": 1},
      {"value": "french", "label": "French", "count": 6},
      {"value": "indian", "label": "Indian", "count": 5},
      {"value": "italian", "label": "Italian", "count": 97},
      {"value": "jewish", "label": "Jewish", "count": 2},
      {"value": "mediterranean", "label": "Mediterranean", "count": 11},
      {"value": "mexican", "label": "Mexican", "count": 1},
      {"value": "middle-eastern", "label": "Middle Eastern", "count": 3},
      {"value": "polish", "label": "Polish", "count": 1},
      {"value": "turkish", "label": "Turkish", "count": 8}
    ]
  },
  {
    "label": "Ratings",
    "name": "ratings",
    "defaultValues": [],
    "options": [
      {"value": "gte-1", "label": "1+ Star", "count": 216},
      {"value": "gte-2", "label": "2+ Star", "count": 214},
      {"value": "gte-3", "label": "3+ Star", "count": 203},
      {"value": "gte-4", "label": "4+ Star", "count": 168},
      {"value": "gte-5", "label": "5+ Star", "count": 44}
    ]
  },
  {
    "label": "Servings",
    "name": "servings",
    "defaultValues": [],
    "options": [
      {"value": "gte-1", "label": "1+ Servings", "count": 157},
      {"value": "gte-2", "label": "2+ Servings", "count": 152},
      {"value": "gte-3", "label": "3+ Servings", "count": 115},
      {"value": "gte-4", "label": "4+ Servings", "count": 114},
      {"value": "gte-5", "label": "5+ Servings", "count": 43},
      {"value": "gte-6", "label": "6+ Servings", "count": 42},
      {"value": "gte-7", "label": "7+ Servings", "count": 19},
      {"value": "gte-8", "label": "8+ Servings", "count": 19}
    ]
  }
];
