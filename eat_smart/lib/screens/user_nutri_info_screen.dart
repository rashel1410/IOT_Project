import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/food_nutrients.dart';

class UserNutriInfoScreen extends StatelessWidget {
  final User user;

  UserNutriInfoScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.getUserName()),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          final food = 3;
          return ListTile(
            title: Text('food.name'),
            subtitle: Text('Calories: , Protein: g, Carbs: g, Fat: g'),
          );
        },
      ),
    );
  }
}

