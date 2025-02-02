import 'package:flutter/material.dart';
import 'package:flutter_ml/models/food_nutrients.dart';
import 'package:percent_indicator/percent_indicator.dart';

class NutrientProgress extends StatelessWidget {
  final Nutrient nutrient;
  final double leftAmount;
  final double progress, width;
  final Color progressColor;

  const NutrientProgress(
      {Key? key,
      required this.nutrient,
      required this.leftAmount,
      required this.progress,
      required this.progressColor,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Text(
                nutrient.nutrientName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                nutrient.value.toString() + " " + nutrient.unitName,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            //mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 90,
                  animation: false,
                  lineHeight: 15.0,
                  percent: 0.8,
                  center: const Text(
                    "80.0%",
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  // linearStrokeCap: LinearStrokeCap.roundAll,

                  progressColor: Colors.redAccent,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
