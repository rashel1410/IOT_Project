import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/food_item.dart';
import 'food_item_screen.dart';

class LastFoodItemScreen extends StatefulWidget {
  @override
  _LastFoodItemScreenState createState() => _LastFoodItemScreenState();
}

class _LastFoodItemScreenState extends State<LastFoodItemScreen> {
  @override
  void initState() {
    super.initState();
    _fetchLastFoodItem();
  }

  Future<void> _fetchLastFoodItem() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await userProvider.fetchLastFoodItem();
    } catch (error) {
      print('Failed to fetch last food item: $error');
    }
  }

  Future<void> _cancelLastFoodItem() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await userProvider.cancelLastFoodItem();
      setState(() {}); // Refresh the UI after canceling the last food item
    } catch (error) {
      print('Failed to cancel last food item: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;
    if (currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (currentUser.foodsList.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Last Food Item',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
        ),
        body: const Center(
          child: Text(
            'No food items found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    final lastFoodItem = currentUser.foodsList.last;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Last Food Item',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final currentUser = userProvider.currentUser;
          final users = userProvider.users;

          if (currentUser == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (currentUser.foodsList.isEmpty) {
            return const Center(child: Text('No food items found'));
          }

          if (lastFoodItem == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      FoodItemScreen.routeName,
                      arguments: lastFoodItem,
                    );
                  },
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lastFoodItem.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('Weight: ${171}g'),
                          const SizedBox(height: 8),
                          const Text('Calories: ${100} kcal'),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _fetchLastFoodItem,
                      child: const Text('Refresh'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _cancelLastFoodItem,
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
