import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

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

  void _saveGoals() {
    if (_formKey.currentState!.validate()) {
      Provider.of<UserProvider>(context, listen: false).setGoals(
        calories: double.parse(_caloriesController.text),
        proteins: double.parse(_proteinsController.text),
        carbs: double.parse(_carbsController.text),
        fats: double.parse(_fatsController.text),
      );
      Navigator.of(context).pop();
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
        title: Text('Edit Goals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _caloriesController,
                decoration: InputDecoration(labelText: 'Calories'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _proteinsController,
                decoration: InputDecoration(labelText: 'Proteins'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
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
                    return 'Please enter a value';
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
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveGoals,
                child: Text('Save Goals'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
