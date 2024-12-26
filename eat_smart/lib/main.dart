// lib/main.dart
import 'package:flutter/material.dart';
import 'models/user.dart';
import 'models/food_item.dart';
import 'screens/user_nutri_info_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: UserFoodScreen(),
    );
  }
}

