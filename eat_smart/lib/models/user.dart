import 'dart:convert';
import 'package:http/http.dart' as http;
import 'food_nutrients.dart';
import 'food_item.dart';
import '../constants.dart';
import 'goals.dart';

class User {
  final String name;
  List<FoodItem> foodsList;
  final String id;
  Goals? goals;

  User(
      {this.id = '',
      this.name = '',
      this.foodsList = const [],
      this.goals = null});

  String getUserName() {
    return this.name; //name;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'foods': this.foodsList,
      'goals': this.goals != null ? this.goals!.toJson() : {},
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      foodsList: json['foods'] == null
          ? []
          : (json['foods'] as List).map((i) => FoodItem.fromJson(i)).toList(),
      goals: json['goals'] != null ? Goals.fromJson(json['goals']) : null,
    );
  }

  Future<List<FoodItem>> getUserFoodsMockData() async {
    // Mock data
    return [
      FoodItem(
        name: 'Apple',
        nutrients: [
          Nutrient(
            nutrientName: 'Vitamin C',
            nutrientNumber: 'C',
            unitName: 'mg',
            value: 5.0,
          ),
          Nutrient(
            nutrientName: 'Fiber',
            nutrientNumber: 'F',
            unitName: 'g',
            value: 2.0,
          ),
        ],
        timestamp: DateTime.now().subtract(Duration(days: 2)),
        id: '1',
        weight: 100.0,
      ),
      FoodItem(
        name: 'Banana',
        nutrients: [
          Nutrient(
            nutrientName: 'Potassium',
            nutrientNumber: 'K',
            unitName: 'mg',
            value: 10.0,
          ),
          Nutrient(
            nutrientName: 'Vitamin B6',
            nutrientNumber: 'B6',
            unitName: 'mg',
            value: 1.0,
          ),
        ],
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        id: '2',
        weight: 120.0,
      ),
      FoodItem(
        name: 'Carrot',
        nutrients: [
          Nutrient(
            nutrientName: 'Vitamin A',
            nutrientNumber: 'A',
            unitName: 'IU',
            value: 100.0,
          ),
          Nutrient(
            nutrientName: 'Fiber',
            nutrientNumber: 'F',
            unitName: 'g',
            value: 3.0,
          ),
        ],
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        id: '3',
        weight: 80.0,
      ),
    ];
  }

  Future<List<FoodItem>> getUserFoods() async {
    var res = await http.get(Uri.parse('$baseUrl'));
    print("Waiting for response from server...");

    if (res.statusCode == 200) {
      print("Response from server:");
      print(res.body);
    } else {
      print('Request failed with status: ${res.statusCode}.');
    }
    return this.getUserFoodsMockData();
  }
}
