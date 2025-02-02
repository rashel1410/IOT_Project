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
              const SizedBox(
                width: 5,
              ),
              Text(
                nutrient.value.toStringAsFixed(1).toString() +
                    " " +
                    nutrient.unitName,
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
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 85,
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
                  // linearStrokeCap: LinearStrokeCap.roundAll,

                  progressColor: progressColor,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
