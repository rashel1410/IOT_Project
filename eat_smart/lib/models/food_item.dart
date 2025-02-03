import 'food_nutrients.dart';

class FoodItem {
  final String name;
  final List<Nutrient> nutrients;
  final DateTime timestamp;
  final String id;
  final double weight;

  FoodItem(
      {required this.name,
      required this.nutrients,
      required this.timestamp,
      required this.id,
      required this.weight});

  // String get getName => name;
  // List<FoodNutrients> get getNutrients => nutrients;
  // DateTime get getTimestamp => timestamp;

  final Map<String, String> mapToCalories = {
    'Calories': 'Calories',
    'Energy': 'Calories',
  };

  double getFoodCalories() {
    double calories = 0;
    for (var nutrient in nutrients) {
      if (nutrient.nutrientNumber == '208') {
        calories = nutrient.value;
        return calories;
      }
    }
    return calories;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['nutrients'] = nutrients.map((v) => v.toJson()).toList();
    data['timestamp'] = timestamp.toIso8601String();
    data['id'] = id;
    data['weight'] = weight.toString();
    return data;
  }

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    var nutrientsFromJson = json['nutrients'] as List;
    List<Nutrient> nutrientsList = nutrientsFromJson.map((nutrientJson) {
      return Nutrient.fromJson(nutrientJson);
    }).toList();

    return FoodItem(
      name: json['name'],
      nutrients: nutrientsList,
      timestamp: DateTime.parse(json['timestamp']),
      id: json['id'],
      weight: json['weight'].toDouble(),
    );
  }
}
