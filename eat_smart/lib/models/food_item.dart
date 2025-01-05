import 'food_nutrients.dart';

class FoodItem {
  final String name;
  final List<FoodNutrients> nutrients;

  FoodItem({required this.name, required this.nutrients});

  FoodItem.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        nutrients = (json['nutrients'] as List)
            .map((i) => FoodNutrients.fromJson(i))
            .toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['nutrients'] = nutrients.map((v) => v.toJson()).toList();
    return data;
  }
}