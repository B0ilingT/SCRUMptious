import 'package:flutter/material.dart';
import 'package:scrumptious/models/category.dart';
import 'package:scrumptious/models/meal.dart';


const availableCategories = [
  Category(
    strId: 'c1',
    strTitle: 'Italian',
    colour: Colors.purple,
  ),
  Category(
    strId: 'c2',
    strTitle: 'Quick & Easy',
    colour: Colors.red,
  ),
  Category(
    strId: 'c3',
    strTitle: 'Burgers',
    colour: Colors.orange,
  ),
  Category(
    strId: 'c4',
    strTitle: 'German',
    colour: Colors.amber,
  ),
  Category(
    strId: 'c5',
    strTitle: 'Light & Lovely',
    colour: Colors.blue,
  ),
  Category(
    strId: 'c6',
    strTitle: 'Exotic',
    colour: Colors.green,
  ),
  Category(
    strId: 'c7',
    strTitle: 'Breakfast',
    colour: Colors.lightBlue,
  ),
  Category(
    strId: 'c8',
    strTitle: 'Asian',
    colour: Colors.lightGreen,
  ),
  Category(
    strId: 'c9',
    strTitle: 'French',
    colour: Colors.pink,
  ),
  Category(
    strId: 'c10',
    strTitle: 'Summer',
    colour: Colors.teal,
  ),
];

const dummyMeals = [
  Meal(
    strId: 'm1',
    arrCategories: [
      'c1',
      'c2',
    ],
    strTitle: 'Spaghetti with Tomato Sauce',
    enumAffordability: Affordability.affordable,
    enumComplexity: Complexity.simple,
    strImageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg/800px-Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg',
    intDuration: 20,
    arrIngredients: [
      '4 Tomatoes',
      '1 Tablespoon of Olive Oil',
      '1 Onion',
      '250g Spaghetti',
      'Spices',
      'Cheese (optional)'
    ],
    arrSteps: [
      'Cut the tomatoes and the onion into small pieces.',
      'Boil some water - add salt to it once it boils.',
      'Put the spaghetti into the boiling water - they should be done in about 10 to 12 minutes.',
      'In the meantime, heaten up some olive oil and add the cut onion.',
      'After 2 minutes, add the tomato pieces, salt, pepper and your other spices.',
      'The sauce will be done once the spaghetti are.',
      'Feel free to add some cheese on top of the finished dish.'
    ],
    bIsGlutenFree: false,
    bIsVegan: true,
    bIsVegetarian: true,
    bIsLactoseFree: true,
  ),
  Meal(
    strId: 'm2',
    arrCategories: [
      'c2',
    ],
    strTitle: 'Toast Hawaii',
    enumAffordability: Affordability.affordable,
    enumComplexity: Complexity.simple,
    strImageUrl:
        'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
    intDuration: 10,
    arrIngredients: [
      '1 Slice White Bread',
      '1 Slice Ham',
      '1 Slice Pineapple',
      '1-2 Slices of Cheese',
      'Butter'
    ],
    arrSteps: [
      'Butter one sstrIde of the white bread',
      'Layer ham, the pineapple and cheese on the white bread',
      'Bake the toast for round about 10 minutes in the oven at 200°C'
    ],
    bIsGlutenFree: false,
    bIsVegan: false,
    bIsVegetarian: false,
    bIsLactoseFree: false,
  ),
  Meal(
    strId: 'm3',
    arrCategories: [
      'c2',
      'c3',
    ],
    strTitle: 'Classic Hamburger',
    enumAffordability: Affordability.pricey,
    enumComplexity: Complexity.simple,
    strImageUrl:
        'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
    intDuration: 45,
    arrIngredients: [
      '300g Cattle Hack',
      '1 Tomato',
      '1 Cucumber',
      '1 Onion',
      'Ketchup',
      '2 Burger Buns'
    ],
    arrSteps: [
      'Form 2 patties',
      'Fry the patties for c. 4 minutes on each sstrIde',
      'Quickly fry the buns for c. 1 minute on each sstrIde',
      'Bruch buns with ketchup',
      'Serve burger with tomato, cucumber and onion'
    ],
    bIsGlutenFree: false,
    bIsVegan: false,
    bIsVegetarian: false,
    bIsLactoseFree: true,
  ),
  Meal(
    strId: 'm4',
    arrCategories: [
      'c4',
    ],
    strTitle: 'Wiener Schnitzel',
    enumAffordability: Affordability.luxurious,
    enumComplexity: Complexity.challenging,
    strImageUrl:
        'https://cdn.pixabay.com/photo/2018/03/31/19/29/schnitzel-3279045_1280.jpg',
    intDuration: 60,
    arrIngredients: [
      '8 Veal Cutlets',
      '4 Eggs',
      '200g Bread Crumbs',
      '100g Flour',
      '300ml Butter',
      '100g Vegetable Oil',
      'Salt',
      'Lemon Slices'
    ],
    arrSteps: [
      'Tenderize the veal to about 2–4mm, and salt on both sstrIdes.',
      'On a flat plate, stir the eggs briefly with a fork.',
      'Lightly coat the cutlets in flour then dip into the egg, and finally, coat in breadcrumbs.',
      'Heat the butter and oil in a large pan (allow the fat to get very hot) and fry the schnitzels until golden brown on both sstrIdes.',
      'Make sure to toss the pan regularly so that the schnitzels are surrounded by oil and the crumbing becomes ‘fluffy’.',
      'Remove, and drain on kitchen paper. Fry the parsley in the remaining oil and drain.',
      'Place the schnitzels on awarmed plate and serve garnishedwith parsley and slices of lemon.'
    ],
    bIsGlutenFree: false,
    bIsVegan: false,
    bIsVegetarian: false,
    bIsLactoseFree: false,
  ),
  Meal(
    strId: 'm5',
    arrCategories: [
      'c2'
          'c5',
      'c10',
    ],
    strTitle: 'Salad with Smoked Salmon',
    enumAffordability: Affordability.luxurious,
    enumComplexity: Complexity.simple,
    strImageUrl:
        'https://cdn.pixabay.com/photo/2016/10/25/13/29/smoked-salmon-salad-1768890_1280.jpg',
    intDuration: 15,
    arrIngredients: [
      'Arugula',
      'Lamb\'s Lettuce',
      'Parsley',
      'Fennel',
      '200g Smoked Salmon',
      'Mustard',
      'Balsamic Vinegar',
      'Olive Oil',
      'Salt and Pepper'
    ],
    arrSteps: [
      'Wash and cut salad and herbs',
      'Dice the salmon',
      'Process mustard, vinegar and olive oil into a dessing',
      'Prepare the salad',
      'Add salmon cubes and dressing'
    ],
    bIsGlutenFree: true,
    bIsVegan: false,
    bIsVegetarian: true,
    bIsLactoseFree: true,
  ),
  Meal(
    strId: 'm6',
    arrCategories: [
      'c6',
      'c10',
    ],
    strTitle: 'Delicious Orange Mousse',
    enumAffordability: Affordability.affordable,
    enumComplexity: Complexity.hard,
    strImageUrl:
        'https://cdn.pixabay.com/photo/2017/05/01/05/18/pastry-2274750_1280.jpg',
    intDuration: 240,
    arrIngredients: [
      '4 Sheets of Gelatine',
      '150ml Orange Juice',
      '80g Sugar',
      '300g Yoghurt',
      '200g Cream',
      'Orange Peel',
    ],
    arrSteps: [
      'Dissolve gelatine in pot',
      'Add orange juice and sugar',
      'Take pot off the stove',
      'Add 2 tablespoons of yoghurt',
      'Stir gelatin under remaining yoghurt',
      'Cool everything down in the refrigerator',
      'Whip the cream and lift it under die orange mass',
      'Cool down again for at least 4 hours',
      'Serve with orange peel',
    ],
    bIsGlutenFree: true,
    bIsVegan: false,
    bIsVegetarian: true,
    bIsLactoseFree: false,
  ),
  Meal(
    strId: 'm7',
    arrCategories: [
      'c7',
    ],
    strTitle: 'Pancakes',
    enumAffordability: Affordability.affordable,
    enumComplexity: Complexity.simple,
    strImageUrl:
        'https://cdn.pixabay.com/photo/2018/07/10/21/23/pancake-3529653_1280.jpg',
    intDuration: 20,
    arrIngredients: [
      '1 1/2 Cups all-purpose Flour',
      '3 1/2 Teaspoons Baking Powder',
      '1 Teaspoon Salt',
      '1 Tablespoon White Sugar',
      '1 1/4 cups Milk',
      '1 Egg',
      '3 Tablespoons Butter, melted',
    ],
    arrSteps: [
      'In a large bowl, sift together the flour, baking powder, salt and sugar.',
      'Make a well in the center and pour in the milk, egg and melted butter; mix until smooth.',
      'Heat a lightly oiled grstrIddle or frying pan over medium high heat.',
      'Pour or scoop the batter onto the grstrIddle, using approximately 1/4 cup for each pancake. Brown on both sstrIdes and serve hot.'
    ],
    bIsGlutenFree: true,
    bIsVegan: false,
    bIsVegetarian: true,
    bIsLactoseFree: false,
  ),
  Meal(
    strId: 'm8',
    arrCategories: [
      'c8',
    ],
    strTitle: 'Creamy Indian Chicken Curry',
    enumAffordability: Affordability.pricey,
    enumComplexity: Complexity.challenging,
    strImageUrl:
        'https://cdn.pixabay.com/photo/2018/06/18/16/05/indian-food-3482749_1280.jpg',
    intDuration: 35,
    arrIngredients: [
      '4 Chicken Breasts',
      '1 Onion',
      '2 Cloves of Garlic',
      '1 Piece of Ginger',
      '4 Tablespoons Almonds',
      '1 Teaspoon Cayenne Pepper',
      '500ml Coconut Milk',
    ],
    arrSteps: [
      'Slice and fry the chicken breast',
      'Process onion, garlic and ginger into paste and sauté everything',
      'Add spices and stir fry',
      'Add chicken breast + 250ml of water and cook everything for 10 minutes',
      'Add coconut milk',
      'Serve with rice'
    ],
    bIsGlutenFree: true,
    bIsVegan: false,
    bIsVegetarian: false,
    bIsLactoseFree: true,
  ),
  Meal(
    strId: 'm9',
    arrCategories: [
      'c9',
    ],
    strTitle: 'Chocolate Souffle',
    enumAffordability: Affordability.affordable,
    enumComplexity: Complexity.hard,
    strImageUrl:
        'https://cdn.pixabay.com/photo/2014/08/07/21/07/souffle-412785_1280.jpg',
    intDuration: 45,
    arrIngredients: [
      '1 Teaspoon melted Butter',
      '2 Tablespoons white Sugar',
      '2 Ounces 70% dark Chocolate, broken into pieces',
      '1 Tablespoon Butter',
      '1 Tablespoon all-purpose Flour',
      '4 1/3 tablespoons cold Milk',
      '1 Pinch Salt',
      '1 Pinch Cayenne Pepper',
      '1 Large Egg Yolk',
      '2 Large Egg Whites',
      '1 Pinch Cream of Tartar',
      '1 Tablespoon white Sugar',
    ],
    arrSteps: [
      'Preheat oven to 190°C. Line a rimmed baking sheet with parchment paper.',
      'Brush bottom and sstrIdes of 2 ramekins lightly with 1 teaspoon melted butter; cover bottom and sstrIdes right up to the rim.',
      'Add 1 tablespoon white sugar to ramekins. Rotate ramekins until sugar coats all surfaces.',
      'Place chocolate pieces in a metal mixing bowl.',
      'Place bowl over a pan of about 3 cups hot water over low heat.',
      'Melt 1 tablespoon butter in a skillet over medium heat. Sprinkle in flour. Whisk until flour is incorporated into butter and mixture thickens.',
      'Whisk in cold milk until mixture becomes smooth and thickens. Transfer mixture to bowl with melted chocolate.',
      'Add salt and cayenne pepper. Mix together thoroughly. Add egg yolk and mix to combine.',
      'Leave bowl above the hot (not simmering) water to keep chocolate warm while you whip the egg whites.',
      'Place 2 egg whites in a mixing bowl; add cream of tartar. Whisk until mixture begins to thicken and a drizzle from the whisk stays on the surface about 1 second before disappearing into the mix.',
      'Add 1/3 of sugar and whisk in. Whisk in a bit more sugar about 15 seconds.',
      'whisk in the rest of the sugar. Continue whisking until mixture is about as thick as shaving cream and holds soft peaks, 3 to 5 minutes.',
      'Transfer a little less than half of egg whites to chocolate.',
      'Mix until egg whites are thoroughly incorporated into the chocolate.',
      'Add the rest of the egg whites; gently fold into the chocolate with a spatula, lifting from the bottom and folding over.',
      'Stop mixing after the egg white disappears. DivstrIde mixture between 2 prepared ramekins. Place ramekins on prepared baking sheet.',
      'Bake in preheated oven until scuffles are puffed and have risen above the top of the rims, 12 to 15 minutes.',
    ],
    bIsGlutenFree: true,
    bIsVegan: false,
    bIsVegetarian: true,
    bIsLactoseFree: false,
  ),
  Meal(
    strId: 'm10',
    arrCategories: [
      'c2',
      'c5',
      'c10',
    ],
    strTitle: 'Asparagus Salad with Cherry Tomatoes',
    enumAffordability: Affordability.luxurious,
    enumComplexity: Complexity.simple,
    strImageUrl:
        'https://cdn.pixabay.com/photo/2018/04/09/18/26/asparagus-3304997_1280.jpg',
    intDuration: 30,
    arrIngredients: [
      'White and Green Asparagus',
      '30g Pine Nuts',
      '300g Cherry Tomatoes',
      'Salad',
      'Salt, Pepper and Olive Oil'
    ],
    arrSteps: [
      'Wash, peel and cut the asparagus',
      'Cook in salted water',
      'Salt and pepper the asparagus',
      'Roast the pine nuts',
      'Halve the tomatoes',
      'Mix with asparagus, salad and dressing',
      'Serve with Baguette'
    ],
    bIsGlutenFree: true,
    bIsVegan: true,
    bIsVegetarian: true,
    bIsLactoseFree: true,
  ),
];