import 'package:flutter/material.dart';
import 'package:flutter_ml/models/food_item.dart';
import 'package:flutter_ml/models/food_nutrients.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'NutrientProgress.dart';

class ProgressCard extends StatefulWidget {
  const ProgressCard({Key? key}) : super(key: key);

  @override
  _ProgressCardState createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).fetchGoals();
    Provider.of<UserProvider>(context, listen: false).fetchAllFoods();
  }

  // List<double> sumNutrients(List<FoodItem> foods) {
  //   Map<String, double> nutrientValuesSums = {};
  //   for (var food in foods) {
  //     for (var nutrient in food.nutrients) {
  //       if (nutrientValuesSums.containsKey(nutrient.nutrientName)) {
  //         if (nutrientValuesSums.containsKey(nutrient.nutrientName)) {
  //           nutrientValuesSums[nutrient.nutrientName] =
  //               (nutrientValuesSums[nutrient.nutrientName] ?? 0.0) +
  //                   nutrient.value;
  //         } else {
  //           nutrientValuesSums[nutrient.nutrientName] = nutrient.value;
  //         }
  //       } else {
  //         nutrientValuesSums[nutrient.nutrientName] = nutrient.value;
  //       }
  //     }
  //   }
  //   return nutrientValuesSums.values.toList();
  // }

  final Map<String, String> nutrientToMacro = {
    'Calories': 'Calories',
    'Energy': 'Calories',
    'Protein': 'Protein',
    'Total Carbohydrate': 'Carbs',
    'Carbohydrate': 'Carbs',
    'Carbohydrate, by difference': 'Carbs',
    'Total Fat': 'Fats',
    'Total lipid (fat)': 'Fats',
    'Total lipid': 'Fats',
    'Fat': 'Fats',
  };

  final Map<String, String> nutrientNumbersToMacros = {
    "208": 'Calories',
    "203": 'Protein',
    "205": 'Carbs',
    "204": 'Fats',
  };

  Map<String, double> sumMacros(List<FoodItem> foods) {
    Map<String, double> nutrientTotals = {
      'Calories': 0.0,
      'Protein': 0.0,
      'Carbs': 0.0,
      'Fats': 0.0,
    };
    for (var food in foods) {
      for (var nutrient in food.nutrients) {
        if (nutrientNumbersToMacros.containsKey(nutrient.nutrientNumber)) {
          String mappedName =
              nutrientNumbersToMacros[nutrient.nutrientNumber] ?? 'Unknown';

          if (mappedName != 'Unknown') {
            nutrientTotals[mappedName] =
                (nutrientTotals[mappedName] ?? 0.0) + nutrient.value;
          }
        }
      }
    }
    return nutrientTotals;
  }

  Future<List<FoodItem>> fetchUserFoods() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchAllFoods();
    return userProvider.currentUser?.foodsList ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      final goals = userProvider.goals;
      final foods = userProvider.currentUser?.foodsList ?? [];

      if (foods.isEmpty) {
        return const Text('No food data available');
      } else {
        final nutrientTotals = sumMacros(foods);
        const progressorWidth = 100.0;

        final calories = Nutrient(
            nutrientName: 'Calories',
            nutrientNumber: '208',
            unitName: 'kcal',
            value: nutrientTotals['Calories'] ?? 0.0);
        final proteins = Nutrient(
            nutrientName: 'Protein',
            nutrientNumber: '203',
            unitName: 'g',
            value: nutrientTotals['Protein'] ?? 0.0);
        final carbs = Nutrient(
            nutrientName: 'Carbs',
            nutrientNumber: '205',
            unitName: 'g',
            value: nutrientTotals['Carbs'] ?? 0.0);
        final fats = Nutrient(
            nutrientName: 'Fats',
            nutrientNumber: '204',
            unitName: 'g',
            value: nutrientTotals['Fats'] ?? 0.0);

        return LayoutBuilder(builder: (context, constraints) {
          final userProvider = Provider.of<UserProvider>(context);
          final currentUser = userProvider.currentUser;
          if (currentUser == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (currentUser.goals == null) {
            return const Center(
              child: Text(
                'No goals found',
                style: TextStyle(fontSize: 20),
              ),
            );
          }
          final caloriesGoal = currentUser.goals?.calories ?? 2000;
          final proteinsGoal = currentUser.goals?.protein ?? 50;
          final carbsGoal = currentUser.goals?.carbs ?? 500;
          final fatsGoal = currentUser.goals?.fats ?? 50;

          if (foods.isEmpty) {
            return const Center(
              child: Text(
                'No food items found',
                style: TextStyle(fontSize: 20),
              ),
            );
          }

          return Container(
            constraints: const BoxConstraints(
              minHeight: 200.0,
              minWidth: 200.0,
            ),
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListTile(
                      title: Text(
                        '${userProvider.currentUser?.name ?? 'User'}\'s Progress',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    NutrientProgress(
                      nutrient: calories,
                      goal: caloriesGoal,
                      progress: (calories.value / caloriesGoal) * 100,
                      progressColor: Colors.red,
                      width: progressorWidth,
                    ),
                    NutrientProgress(
                      nutrient: proteins,
                      goal: proteinsGoal,
                      progress: (proteins.value / caloriesGoal) * 100,
                      progressColor: Colors.green,
                      width: progressorWidth,
                    ),
                    NutrientProgress(
                      nutrient: carbs,
                      goal: carbsGoal,
                      progress: (carbs.value / caloriesGoal) * 100,
                      progressColor: Colors.blue,
                      width: progressorWidth,
                    ),
                    NutrientProgress(
                      nutrient: fats,
                      goal: fatsGoal,
                      progress: (fats.value / caloriesGoal) * 100,
                      progressColor: Colors.purple,
                      width: progressorWidth,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      }
    });
  }
}
