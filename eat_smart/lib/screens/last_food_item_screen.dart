import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/food_item.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Last Food Item',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
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

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (currentUser != null && currentUser.foodsList.isNotEmpty)
                  Text(
                    'Last Food Item: ${currentUser.foodsList.last.name}',
                    style: const TextStyle(fontSize: 20),
                  )
                else
                  const Text(
                    'No food item found',
                    style: TextStyle(fontSize: 20),
                  ),
                const SizedBox(height: 20),
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
