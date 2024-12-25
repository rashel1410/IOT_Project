// lib/main.dart
import 'package:flutter/material.dart';
import 'models/user.dart';
import 'models/food_item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserFoodScreen(),
    );
  }
}

class UserFoodScreen extends StatefulWidget {
  @override
  _UserFoodScreenState createState() => _UserFoodScreenState();
}

class _UserFoodScreenState extends State<UserFoodScreen> {
  late Future<List<FoodItem>> items;

  @override
  void initState() {
    super.initState();
    User user = User(name: 'John Doe', foods: []);
    items = user.getUserFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Food Items'),
      ),
      body: FutureBuilder<List<FoodItem>>(
        future: items,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No food items found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final foodItem = snapshot.data![index];
                return ListTile(
                  title: Text(foodItem.name),
                  subtitle: Text(foodItem.nutrients.map((n) => 'protein').join(', ')),
                );
              },
            );
          }
        },
      ),
    );
  }
}