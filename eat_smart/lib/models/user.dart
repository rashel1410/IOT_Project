import 'dart:convert';
import 'package:http/http.dart' as http;
import 'food_nutrients.dart';
import 'food_item.dart';

class User {
  final String name;
  final List<FoodItem> foods;
  User({this.name = '', this.foods = const []});

  String getUserName() {
    return this.name; //name;
  }

  Future<List<FoodItem>> getUserFoodsMockData() async {
    // Mock data
    return [
      FoodItem(
        name: 'Apple',
        nutrients: [
          FoodNutrients(
            nutrientId: 1,
            nutrientName: 'Vitamin C',
            nutrientNumber: 'C',
            unitName: 'mg',
            value: 5.0,
          ),
          FoodNutrients(
            nutrientId: 2,
            nutrientName: 'Fiber',
            nutrientNumber: 'F',
            unitName: 'g',
            value: 2.0,
          ),
        ],
      ),
      FoodItem(
        name: 'Banana',
        nutrients: [
          FoodNutrients(
            nutrientId: 3,
            nutrientName: 'Potassium',
            nutrientNumber: 'K',
            unitName: 'mg',
            value: 10.0,
          ),
          FoodNutrients(
            nutrientId: 4,
            nutrientName: 'Vitamin B6',
            nutrientNumber: 'B6',
            unitName: 'mg',
            value: 1.0,
          ),
        ],
      ),
      FoodItem(
        name: 'Carrot',
        nutrients: [
          FoodNutrients(
            nutrientId: 5,
            nutrientName: 'Vitamin A',
            nutrientNumber: 'A',
            unitName: 'IU',
            value: 100.0,
          ),
          FoodNutrients(
            nutrientId: 6,
            nutrientName: 'Fiber',
            nutrientNumber: 'F',
            unitName: 'g',
            value: 3.0,
          ),
        ],
      ),
    ];
  }

  Future<List<FoodItem>> getUserFoods() async {
    var backendIP = '192.168.68.110';
    var port = '8045';
    var res = await http.get(Uri.parse('http://$backendIP:$port'));
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
