import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http; // Add this line
import '../providers/user_provider.dart';
import '../constants.dart';

class EditGoalsScreen extends StatefulWidget {
  static const routeName = '/edit_goals_screen';

  @override
  _EditGoalsScreenState createState() => _EditGoalsScreenState();
}

class _EditGoalsScreenState extends State<EditGoalsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _caloriesController = TextEditingController();
  final _proteinsController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatsController = TextEditingController();

  @override
  void dispose() {
    _caloriesController.dispose();
    _proteinsController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  void setGoals() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;
    final userId = currentUser?.id;

    // final url = '$baseUrl/set_goals/$userId';

    // final response = await http.post(
    //   Uri.parse(url),
    //   body: {
    //     'calories': _caloriesController.text,
    //     'proteins': _proteinsController.text,
    //     'carbs': _carbsController.text,
    //     'fats': _fatsController.text,
    //   },
    // );

    final calories = _caloriesController.text;
    final protein = _proteinsController.text;
    final carbs = _carbsController.text;
    final fats = _fatsController.text;

    final url =
        Uri.parse('$baseUrl/set_goals/$userId').replace(queryParameters: {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
    });

    final response = await http.post(url);

    if (response.statusCode == 200) {
      // Goals successfully set
      print('Goals set successfully');
      userProvider.fetchGoals();
    } else {
      // Failed to set goals
      print('Failed to set goals. Error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userGoals = userProvider.currentUser?.goals;

    _caloriesController.text = userGoals?.calories.toString() ?? '';
    _proteinsController.text = userGoals?.proteins.toString() ?? '';
    _carbsController.text = userGoals?.carbs.toString() ?? '';
    _fatsController.text = userGoals?.fats.toString() ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Goals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              return Column(
                children: [
                  TextFormField(
                    controller: _caloriesController,
                    decoration: const InputDecoration(labelText: 'Calories'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '${userGoals?.calories.toString()}';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _proteinsController,
                    decoration: const InputDecoration(labelText: 'Proteins'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '${userGoals?.proteins.toString()}';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _carbsController,
                    decoration: InputDecoration(labelText: 'Carbs'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '${userGoals?.carbs.toString()}';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _fatsController,
                    decoration: InputDecoration(labelText: 'Fats'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '${userGoals?.fats.toString()}';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setGoals();
                      userProvider.fetchGoals();
                    },
                    child: Text('Save Goals'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
