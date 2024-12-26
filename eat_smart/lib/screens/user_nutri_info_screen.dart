import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/food_item.dart';

class UserFoodScreen extends StatefulWidget {
  const UserFoodScreen({Key? key}) : super(key: key);

  @override
  _UserFoodScreenState createState() => _UserFoodScreenState();
}

class _UserFoodScreenState extends State<UserFoodScreen> {
  late Future<List<FoodItem>> items;
  late User user;

  @override
  void initState() {
    super.initState();
    user = User(name: 'Dani', foods: []);
    items = user.getUserFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        title: Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 20.0), // Add padding to the top
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hey ${user.getUserName()}!'),
              SizedBox(height: 7), // Add vertical space
              Text('Here\'s what you ate today:'),
            ],
          ),
        ),
      ),

      body: FutureBuilder<List<FoodItem>>(
        future: items,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No food items found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final foodItem = snapshot.data![index];
                return ListTile(
                  title: Text(foodItem.name),
                  subtitle: Text(
                      foodItem.nutrients.map(
                              (nutrient) => '${nutrient.nutrientName}: ${nutrient.value} ${nutrient.unitName}').join(', ')
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}