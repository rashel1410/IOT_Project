import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  List<User> _users = [];

  User? get currentUser => _currentUser;
  List<User> get users => _users;

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/get_users'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      _users = data.entries.map((entry) {
        var userData = entry.value;
        userData['id'] = entry.key; // Add the ID to the user data
        return User.fromJson(userData);
      }).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load users');
    }
  }

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}
