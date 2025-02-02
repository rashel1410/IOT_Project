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
    //Provider.of<UserProvider>(context, listen: false).fetchAllFoods();
  }

  List<double> sumNutrients(List<FoodItem> foods) {
    Map<String, double> nutrientValuesSums = {};
    for (var food in foods) {
      for (var nutrient in food.nutrients) {
        if (nutrientValuesSums.containsKey(nutrient.nutrientName)) {
          if (nutrientValuesSums.containsKey(nutrient.nutrientName)) {
            nutrientValuesSums[nutrient.nutrientName] =
                (nutrientValuesSums[nutrient.nutrientName] ?? 0.0) +
                    nutrient.value;
          } else {
            nutrientValuesSums[nutrient.nutrientName] = nutrient.value;
          }
        } else {
          nutrientValuesSums[nutrient.nutrientName] = nutrient.value;
        }
      }
    }
    return nutrientValuesSums.values.toList();
  }

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

  Map<String, double> sumMacros(List<FoodItem> foods) {
    Map<String, double> nutrientTotals = {
      'Calories': 0.0,
      'Protein': 0.0,
      'Carbs': 0.0,
      'Fats': 0.0,
    };
    for (var food in foods) {
      for (var nutrient in food.nutrients) {
        if (nutrientToMacro.containsKey(nutrient.nutrientName)) {
          String mappedName =
              nutrientToMacro[nutrient.nutrientName] ?? 'Unknown';

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
    return FutureBuilder<List<FoodItem>>(
      future: fetchUserFoods(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No food data available');
        } else {
          final nutrientTotals = sumMacros(snapshot.data!);
          const progressorWidth = 100.0;

          final calories = Nutrient(
              nutrientName: 'Calories',
              nutrientNumber: 'C',
              unitName: 'kcal',
              value: nutrientTotals['Calories'] ?? 0.0);
          final proteins = Nutrient(
              nutrientName: 'Protein',
              nutrientNumber: 'P',
              unitName: 'g',
              value: nutrientTotals['Protein'] ?? 0.0);
          final carbs = Nutrient(
              nutrientName: 'Carbs',
              nutrientNumber: 'C',
              unitName: 'g',
              value: nutrientTotals['Carbs'] ?? 0.0);
          final fats = Nutrient(
              nutrientName: 'Fat',
              nutrientNumber: 'F',
              unitName: 'g',
              value: nutrientTotals['Fats'] ?? 0.0);

          return LayoutBuilder(builder: (context, constraints) {
            final userProvider = Provider.of<UserProvider>(context);
            // Now you can use userProvider as needed
            if (userProvider.currentUser == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.isEmpty) {
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
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const ListTile(
                        title: Text(
                          'Food Items',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      NutrientProgress(
                        nutrient: calories,
                        leftAmount: calories.value,
                        progress: calories.value / 1000,
                        progressColor: Colors.red,
                        width: progressorWidth,
                      ),
                      NutrientProgress(
                        nutrient: proteins,
                        leftAmount: proteins.value,
                        progress: proteins.value / 1000,
                        progressColor: Colors.green,
                        width: progressorWidth,
                      ),
                      NutrientProgress(
                        nutrient: carbs,
                        leftAmount: carbs.value,
                        progress: carbs.value / 1000,
                        progressColor: Colors.blue,
                        width: progressorWidth,
                      ),
                      NutrientProgress(
                        nutrient: fats,
                        leftAmount: fats.value,
                        progress: fats.value / 1000,
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
      },
    );
  }
}
