import 'package:flutter/material.dart';
import '../models/food_nutrients.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';
import '../models/food_item.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  List<User> _users = [];
  FoodItem? _lastFoodItem;

  User? get currentUser => _currentUser;
  List<User> get users => _users;
  FoodItem? get lastFoodItem => _lastFoodItem;

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/get_users'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      _users = data.entries.map((entry) {
        var userDataJson = {
          'id': entry.key,
          'name': entry.value,
          'foods': [],
        };
        // Add the ID to the user data
        return User.fromJson(userDataJson);
      }).toList();

      notifyListeners();
    } else {
      throw Exception('Failed to load users');
    }
  }

  void setUser(User user) {
    _currentUser = user;
    fetchAllFoods();
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> fetchAllFoods() async {
    if (_currentUser != null) {
      final response = await http
          .get(Uri.parse('$baseUrl/get_user_foods/${_currentUser!.id}'));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<FoodItem> foodList = data.entries.map((entry) {
          var foodData = entry.value;
          FoodItem foodItemFromJson = FoodItem(
            id: entry.key,
            name: foodData['name'],
            timestamp: DateTime.parse(foodData['timestamp']),
            nutrients: foodData['nutrients']
                .map<Nutrient>((nutrient) => Nutrient.fromJson(nutrient))
                .toList(),
            weight: foodData['weight'].toDouble(),
          );
          //FoodItem foodItem = FoodItem.fromJson(foodData);
          return foodItemFromJson;
        }).toList();

        // Sort the list by timestamp
        foodList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        // Store the sorted list in the User object
        _currentUser!.foodsList = foodList;
        _lastFoodItem = _currentUser!.foodsList.isNotEmpty
            ? _currentUser!.foodsList.last
            : null;
        notifyListeners();
      } else {
        throw Exception('Failed to load foods');
      }
    }
  }

  Future<void> fetchLastFoodItem() async {
    if (_currentUser != null) {
      final response = await http
          .get(Uri.parse('$baseUrl/get_last_food_item/${_currentUser!.id}'));
      if (response.statusCode == 200) {
        final lastFoodItem = FoodItem.fromJson(json.decode(response.body));
        notifyListeners();
      } else {
        throw Exception('Failed to load last food item');
      }
    }
  }

  Future<void> cancelLastFoodItem() async {
    if (_currentUser != null && _currentUser!.foodsList.isNotEmpty) {
      final lastFoodItem = _currentUser!.foodsList.last;
      final userId = _currentUser!.id;
      final itemId = lastFoodItem.id;

      final url = Uri.parse('$baseUrl/remove_food_item/$userId/$itemId');

      final response = await http.post(url);

      if (response.statusCode == 200) {
        _currentUser!.foodsList.removeLast();
        await fetchAllFoods();

        notifyListeners();
      } else {
        throw Exception('Failed to remove food item: ${response.body}');
      }
    }
  }
}
