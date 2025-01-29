// lib/main.dart
import 'package:flutter/material.dart';
import 'models/user.dart';
import 'screens/home_screen.dart';
import 'models/food_item.dart';
import 'screens/last_food_item_screen.dart';
import 'screens/user_nutri_info_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_user_screen.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';

void main() {
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: {
        '/add_user_screen': (context) => AddUserScreen(),
        '/last_food_item_screen': (context) => LastFoodItemScreen(),
      },
    );
  }
}
