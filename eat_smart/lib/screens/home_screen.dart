import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart'; // Import your user provider
import '../models/user.dart'; // Import your user model

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eat Smart'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              currentUser != null
                  ? 'Welcome, ${currentUser.name}!'
                  : 'Welcome to Eat Smart!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 60),
            const Text('Choose a user:'),
            DropdownButton<String>(
              value: currentUser?.id,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  // Update the current user
                  userProvider.setUser(User(id: newValue, name: newValue));
                }
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
