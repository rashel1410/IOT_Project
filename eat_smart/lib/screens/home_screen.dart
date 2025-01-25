import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eat Smart'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Eat Smart!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 60),
            const Text('Choose a user:'),
            DropdownButton<String>(
              value: 'User1',
              onChanged: (String? newValue) {
                // Handle user selection
              },
              items: <String>['User1', 'User2', 'User3', 'User4']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the AddUserScreen
                Navigator.pushNamed(context, '/add_user_screen');
              },
              child: const Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }
}
