// lib/main.dart
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter_ml/screens/all_food_items_screen.dart';
import 'models/user.dart';
import 'screens/edit_goals_screen.dart';
import 'screens/food_item_screen.dart';
import 'screens/home_screen.dart';
import 'screens/last_food_item_screen.dart';
import 'screens/add_user_screen.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';

void main() {
  tz.initializeTimeZones();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eat Smart',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
      home: HomeScreen(),
      routes: {
        '/add_user_screen': (context) => AddUserScreen(),
        '/last_food_item_screen': (context) => LastFoodItemScreen(),
        FoodItemScreen.routeName: (context) => FoodItemScreen(),
        AllFoodItemsScreen.routeName: (context) => AllFoodItemsScreen(),
        EditGoalsScreen.routeName: (context) => EditGoalsScreen(),
        EditGoalsScreen.routeName: (context) => EditGoalsScreen(),
      },
    );
  }
}
