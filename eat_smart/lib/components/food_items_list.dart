import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import 'NutrientProgress.dart';
import '../providers/user_provider.dart';
import 'progress_card.dart';
import '../screens/food_item_screen.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FoodItemsListWidget extends StatelessWidget {
  const FoodItemsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final foodsList = userProvider.currentUser?.foodsList ?? [];

        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 100),
                  ProgressCard(),
                  // Add any other widgets you want to display at the top
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('My Food Items:'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final FoodItem foodItem =
                      foodsList[foodsList.length - 1 - index];
                  final tz.TZDateTime israelTime = tz.TZDateTime.from(
                    foodItem.timestamp,
                    tz.getLocation('Asia/Jerusalem'),
                  );
                  return Container(
                    height: 60,
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  foodItem.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '${foodItem.weight} gr',
                                  style: const TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                //add the time here
                                Text(
                                  '${DateFormat('HH:mm').format(israelTime)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '${DateFormat('dd.MM.yy').format(israelTime)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            FoodItemScreen.routeName,
                            arguments: foodItem,
                          );
                        },
                      ),
                    ),
                  );
                },
                childCount: foodsList.length,
              ),
            ),
          ],
        );
      },
    );
  }
}
