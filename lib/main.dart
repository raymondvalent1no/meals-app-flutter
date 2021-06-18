import 'package:flutter/material.dart';
import 'package:mealsapp_flutter/dummy_data.dart';
import 'package:mealsapp_flutter/models/meal.dart';
import './screens/tabs_screen.dart';

import './screens/categories_screen.dart';
import './screens/category_meals_screen.dart';
import './screens/meal_detail_screen.dart';
import './screens/filters_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    // kondisi awal -> property awal (false)
    'gluten': false,
    'lactose': false,
    'vegetarian': false,
    'vegan': false,
  };

  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favoriteMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    setState(
      () {
        _filters =
            filterData; // hasil data filter yg di dapat dari pilihan filter user di selectedFilters di filters_screen.dart
        _availableMeals = DUMMY_MEALS.where((meal) {
          if (_filters['gluten'] && !meal.isGlutenFree) {
            return false;
          }
          if (_filters['lactose'] && !meal.isLactoseFree) {
            return false;
          }
          if (_filters['vegetarian'] && !meal.isVegetarian) {
            return false;
          }
          if (_filters['vegan'] && !meal.isVegan) {
            return false;
          }
          return true;
        }).toList();
      },
    );
  }

  void _toggleFavorite(String mealId) {
    final existingIndex = _favoriteMeals.indexWhere((meal) =>
        meal.id ==
        mealId); //cari/filter + return/get index dari yg lolos/didapatkan

    if (existingIndex >= 0) {
      setState(() {
        _favoriteMeals.removeAt(
            existingIndex); //if sudah ada difavorite, maka akan remove
      });
    } else {
      setState(() {
        _favoriteMeals.add(DUMMY_MEALS.firstWhere(
            (meal) => meal.id == mealId)); // sebaliknya, akan add, firstWhere
      });
    }
  }

  bool _isMealFavorite(String id) {
    return _favoriteMeals.any((meal) => meal.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meals App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(250, 245, 225, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                color: Color.fromRGBO(20, 50, 50, 1),
              ),
              bodyText2: TextStyle(
                color: Color.fromRGBO(20, 50, 50, 1),
              ),
              headline6: TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
      /* home: CategoriesScreen(), */
      initialRoute: '/',
      routes: {
        '/': (ctx) => TabsScreen(_favoriteMeals),
        CategoryMealsScreen.routeName: (ctx) =>
            CategoryMealsScreen(_availableMeals),
        MealDetailScreen.routeName: (ctx) =>
            MealDetailScreen(_toggleFavorite, _isMealFavorite),
        FiltersScreen.routeName: (ctx) => FiltersScreen(_filters, _setFilters),
      },
      onGenerateRoute: (settings) {
        print(settings.arguments);
        return MaterialPageRoute(
          builder: (ctx) => CategoriesScreen(),
        );
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => CategoriesScreen(),
        );
      },
    );
  }
}
