import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart'; // Import your user provider
import '../models/user.dart'; // Import your user model

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() {
    Provider.of<UserProvider>(context, listen: false).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Eat Smart'),
        ),
        body: Consumer<UserProvider>(builder: (context, userProvider, child) {
          final currentUser = userProvider.currentUser;
          final users = userProvider.users;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      final selectedUser =
                          users.firstWhere((user) => user.id == newValue);
                      userProvider.setUser(selectedUser);
                    }
                  },
                  items: users.map<DropdownMenuItem<String>>((User user) {
                    return DropdownMenuItem<String>(
                      value: user.id,
                      child: Text(user.name),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final result =
                        await Navigator.pushNamed(context, '/add_user_screen');
                    if (result == true) {
                      _fetchUsers(); // Refresh the user list
                    }
                  },
                  child: Text('Add User'),
                ),
              ],
            ),
          );
        }));
  }
}
