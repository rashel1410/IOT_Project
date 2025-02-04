import 'package:flutter/material.dart';
import '../models/food_nutrients.dart';

class NutrientsList extends StatelessWidget {
  final List<Nutrient> nutrients;

  const NutrientsList({Key? key, required this.nutrients}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            //shrinkWrap: true,
            //physics: const ScrollPhysics(),
            itemCount: nutrients.length,
            itemBuilder: (context, index) {
              final nutrient = nutrients[index];
              return Card(
                elevation: 5,
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${nutrient.nutrientName}:',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        '${nutrient.value.toStringAsFixed(2)} ${nutrient.unitName.toLowerCase()}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );

              // return Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 5.0),
              //     child: buildRow(nutrient.nutrientName, nutrient.value,
              //         nutrient.unitName.toLowerCase()));
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$nutrientName:',
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            '$value ${unitName.toLowerCase()}',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
