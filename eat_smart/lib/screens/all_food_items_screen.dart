import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/food_items_list.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class AllFoodItemsScreen extends StatefulWidget {
  static String routeName = '/all_food_items_screen.dart';

  const AllFoodItemsScreen({Key? key}) : super(key: key);

  @override
  _AllFoodItemsScreenState createState() => _AllFoodItemsScreenState();
}

class _AllFoodItemsScreenState extends State<AllFoodItemsScreen> {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final today = DateTime.now();

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchAllFoods();
    userProvider.fetchGoals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
            "${DateFormat("EEEE").format(today)}, ${DateFormat("d MMMM").format(today)}",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final currentUser = userProvider.currentUser;

          if (currentUser != null && currentUser.foodsList.isNotEmpty) {
            return const Center(
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: FoodItemsListWidget()));
          } else {
            return const Text(
              'No food items found',
              style: TextStyle(fontSize: 20),

              // const Expanded(
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.only(
              //       topLeft: Radius.circular(50),
              //       topRight: Radius.circular(50),
              //     ),
              //   ),
              // )
            );
          }
        },
      ),
    );
  }
}
