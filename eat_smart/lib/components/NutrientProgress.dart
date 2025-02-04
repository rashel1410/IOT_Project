import 'package:flutter/material.dart';
import 'package:flutter_ml/models/food_nutrients.dart';
import 'package:percent_indicator/percent_indicator.dart';

class NutrientProgress extends StatelessWidget {
  final Nutrient nutrient;
  final double goal;
  final double progress, width;
  final Color progressColor;

  const NutrientProgress(
      {Key? key,
      required this.nutrient,
      required this.goal,
      required this.progress,
      required this.progressColor,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percent = progress / 100;
    percent = percent > 1.0 ? 1.0 : percent;
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(8.0), // Add padding to the card
        child: Container(
          width: constraints.maxWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    nutrient.nutrientName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // const SizedBox(
                  //   width: 100,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "${nutrient.value.toStringAsFixed(1)} ${nutrient.unitName}",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        " / ${goal.toStringAsFixed(1)} ${nutrient.unitName}",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                  height: 8), // Add spacing between the rows and progress bar

              LinearPercentIndicator(
                width: constraints.maxWidth *
                    0.9, // Set the width to match the parent constraints
                animation: false,
                lineHeight: 15.0,
                percent: percent,
                center: Text(
                  "${progress.toStringAsFixed(1)}%",
                  style: const TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                progressColor: progressColor,
              ),
            ],
          ),
        ),
      );
    });
  }
}
