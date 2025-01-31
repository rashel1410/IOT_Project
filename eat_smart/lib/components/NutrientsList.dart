import 'package:flutter/material.dart';
import '../models/food_nutrients.dart';

class NutrientsListWidget extends StatelessWidget {
  final List<FoodNutrients> nutrients;

  const NutrientsListWidget({Key? key, required this.nutrients})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: nutrients.length,
            itemBuilder: (context, index) {
              final nutrient = nutrients[index];
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: buildRow(nutrient.nutrientName, nutrient.value,
                      nutrient.unitName));
            },
          ),
        ),
      ],
    );
  }

  buildRow(String nutrientName, double value, String unitName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Text(
            '$nutrientName: $value $unitName',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
