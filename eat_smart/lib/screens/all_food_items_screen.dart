import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/NutrientsList.dart';
import '../providers/user_provider.dart';
import '../models/food_item.dart';

class AllFoodItemsScreen extends StatefulWidget {
  static String routeName = '/all_food_items_sceen.dart';

  const AllFoodItemsScreen({Key? key}) : super(key: key);

  @override
  _AllFoodItemsScreenState createState() => _AllFoodItemsScreenState();
}

class _AllFoodItemsScreenState extends State<AllFoodItemsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Today ${DateTime.now().toString().split(' ')[0]}',
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

          return Column(
            children: [
              if (currentUser != null && currentUser.foodsList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    margin: const EdgeInsets.only(top: 25, left: 12, right: 12),
                    child: const Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'food1',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' gr',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '23 calories',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              else
                const Text(
                  'No food item found',
                  style: TextStyle(fontSize: 20),
                ),
              const SizedBox(height: 30),
              const Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
