import 'dart:convert';
import 'package:http/http.dart' as http;
import 'food_item.dart';

class User {
  final String name;
  final List<FoodItem> foods;
  User({required this.name, required this.foods});

  String getUserName() {
    return ''; //name;
  }

  Future<List<FoodItem>> getUserFoods() async{
    var backendIP = '10.100.102.19';
    var port = '8045';
    print("1111");
    var res = await http.get(
        Uri.parse('http://' + backendIP + ':' + port)
    );
    print("2222");

    if (res.statusCode == 200) {
      print("3333");
      print(res.body);
      List<dynamic> body = jsonDecode(res.body);
      List<FoodItem> foodItems = body.map((dynamic item) => FoodItem.fromJson(item)).toList();
      return foodItems;
    } else {
      throw Exception('Failed to load food items');
    }
  }
}

