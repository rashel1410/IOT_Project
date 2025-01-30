import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart'; // Import your user provider
import '../models/user.dart';
import 'add_user_screen.dart';
import 'last_food_item_screen.dart'; // Import your user model

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

  Future<void> _fetchUsers() async {
    try {
      await Provider.of<UserProvider>(context, listen: false).fetchUsers();
    } catch (error) {
      print('Failed to fetch users: $error');
    }
  }

  Future<void> _fetchFoods() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await userProvider.fetchAllFoods();
    } catch (error) {
      print('Failed to fetch foods: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Home',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
        ),
        body: SafeArea(
          child:
              Consumer<UserProvider>(builder: (context, userProvider, child) {
            final currentUser = userProvider.currentUser;
            final users = userProvider.users;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      onChanged: (String? newValue) async {
                        if (newValue != null) {
                          final selectedUser =
                              users.firstWhere((user) => user.id == newValue);
                          userProvider.setUser(selectedUser);
                          await _fetchFoods();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LastFoodItemScreen()),
                          );
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
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddUserScreen()),
                        );
                        if (result == true) {
                          await _fetchUsers(); // Refresh the user list
                        }
                      },
                      child: const Text('Add User'),
                    ),
                  ],
                ),
              ),
            );
          }),
        ));
  }
}
