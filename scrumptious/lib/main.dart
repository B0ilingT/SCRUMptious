import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrumptious/data/dummy_data.dart';
import 'package:scrumptious/data/temp_meals.dart';
import 'package:scrumptious/models/meal.dart';
import 'package:scrumptious/screens/shared/tabs.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 131, 57, 0),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

const FlutterSecureStorage storage = FlutterSecureStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tempMeals = await _loadMeals();
  runApp(const ProviderScope(child: App()));
}

Future<List<Meal>> _loadMeals() async {
  final String? mealDataString2 = await storage.read(key: 'meals');
  if (mealDataString2 != null) {
    final List<Map<String, dynamic>> mealData =
        jsonDecode(mealDataString2).cast<Map<String, dynamic>>();
    return mealData.map((data) => Meal.fromJson(data)).toList();
  } else {
    return dummyMeals;
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _saveMeals();
    }
  }

  Future<void> _saveMeals() async {
    final String mealDataString = jsonEncode(tempMeals
        .where((meal) => !meal.arrCategories.contains('c-1'))
        .map((meal) => meal.toJson())
        .toList());
    await storage.write(key: 'meals', value: mealDataString);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: const TabsScreen());
  }
}
