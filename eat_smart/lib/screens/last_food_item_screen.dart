import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/food_item.dart';
import 'all_food_items_screen.dart';
import 'food_item_screen.dart';
import 'user_nutri_info_screen.dart';

class LastFoodItemScreen extends StatefulWidget {
  @override
  _LastFoodItemScreenState createState() => _LastFoodItemScreenState();
}

class _LastFoodItemScreenState extends State<LastFoodItemScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _updateLastFoodItem() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await userProvider.fetchAllFoods();
    } catch (error) {
      print('Failed to update last food item: $error');
    }
  }

  Future<void> _cancelLastFoodItem() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await userProvider.cancelLastFoodItem();
      //await userProvider.fetchLastFoodItem();
      //await userProvider.fetchAllFoods();
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
          if (userProvider.lastFoodItem == null) {
            return const Center(child: CircularProgressIndicator());
          }

          //final lastFoodItem = currentUser.foodsList.last;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          FoodItemScreen.routeName,
                          arguments: userProvider.lastFoodItem,
                        );
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 25, left: 12, right: 12),
                        width: 350,
                        height: 150,
                        child: Card(
                          color: Colors.grey[200],
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  userProvider.lastFoodItem!.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                    'Weight: ${userProvider.lastFoodItem!.weight}g'),
                                const SizedBox(height: 8),
                                Text(
                                    'Calories: ${userProvider.lastFoodItem!.getFoodCalories()} kcal'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _updateLastFoodItem,
                      icon: Icon(Icons.refresh),
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      onPressed: _cancelLastFoodItem,
                      icon: Icon(Icons.cancel),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, AllFoodItemsScreen.routeName);
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 25, left: 12, right: 12),
                        width: 130,
                        height: 60,
                        child: Card(
                          color: Colors.grey[200],
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(1.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'View all',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
