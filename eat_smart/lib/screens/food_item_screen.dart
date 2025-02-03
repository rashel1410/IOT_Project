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
  }

  // final Map<String, String> mapToCalories = {
  //   'Calories': 'Calories',
  //   'Energy': 'Calories',
  // };

  // double getUserCalories(FoodItem foodItem) {
  //   double calories = 0;
  //   for (var nutrient in foodItem.nutrients) {
  //     if (mapToCalories.containsKey(nutrient.nutrientName)) {
  //       calories = nutrient.value;
  //       return calories;
  //     }
  //   }
  //   return calories;
  // }

  @override
  Widget build(BuildContext context) {
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

          return Column(
            children: [
              if (currentUser != null && currentUser.foodsList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    margin: const EdgeInsets.only(top: 25, left: 12, right: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                '${selectedFoodItem.name}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            Text(
                              '${selectedFoodItem.weight} gr',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${selectedFoodItem.getFoodCalories()} calories',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              else
                const Text(
                  'No food item found',
                  style: TextStyle(fontSize: 20),
                ),
              const SizedBox(height: 30),
              NutrientsListInContainer(selectedFoodItem: selectedFoodItem)
            ],
          );
        },
      ),
    );
  }
}

class NutrientsListInContainer extends StatelessWidget {
  const NutrientsListInContainer({
    Key? key,
    required this.selectedFoodItem,
  }) : super(key: key);

  final FoodItem selectedFoodItem;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 153, 187, 237),
          ),
          padding: const EdgeInsets.only(top: 40, left: 18, right: 18),
          child: NutrientsList(nutrients: selectedFoodItem.nutrients),
        ),
      ),
    );
  }
}
