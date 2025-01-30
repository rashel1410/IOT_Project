import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/NutrientsList.dart';
import '../providers/user_provider.dart';
import '../models/food_item.dart';

class FoodItemScreen extends StatefulWidget {
  static String routeName = '/food_item_screen.dart';
  final FoodItem? foodItem;

  const FoodItemScreen({Key? key, this.foodItem}) : super(key: key);

  @override
  _FoodItemScreenState createState() => _FoodItemScreenState();
}

class _FoodItemScreenState extends State<FoodItemScreen> {
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
    final FoodItem selectedFoodItem =
        ModalRoute.of(context)!.settings.arguments as FoodItem;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Food Item Info',
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

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (currentUser != null && currentUser.foodsList.isNotEmpty)
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${selectedFoodItem.name}',
                          style: const TextStyle(fontSize: 30),
                        ),
                        Text(
                          '${selectedFoodItem.nutrients[0].value} calories',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  )
                else
                  const Text(
                    'No food item found',
                    style: TextStyle(fontSize: 20),
                  ),
                const SizedBox(height: 20),
                NutrientsListWidget(nutrients: selectedFoodItem.nutrients),
              ],
            ),
          );
        },
      ),
    );
  }
}
