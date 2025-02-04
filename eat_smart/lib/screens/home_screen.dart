import 'package:flutter/material.dart';
import 'package:flutter_ml/screens/all_food_items_screen.dart';
import 'package:flutter_ml/screens/edit_goals_screen.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart'; // Import your user provider
import '../models/user.dart';
import 'add_user_screen.dart';
import 'last_food_item_screen.dart'; // Import your user model
import '../components/custom_bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LastFoodItemScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllFoodItemsScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditGoalsScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
    }
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

  Future<void> _fetchGoals() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await userProvider.fetchGoals();
    } catch (error) {
      print('Failed to fetch goals: $error');
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          await _fetchGoals();
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
        ),
        //bottomNavigationBar: CustomBottomNavigationBar()
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          iconSize: 22,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          fixedColor: Colors.black,
          showSelectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.scale),
              label: 'Last Scale',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.food_bank_rounded),
              label: 'View Foods',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Set Goals',
            ),
          ],
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          //selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ));
  }
}
