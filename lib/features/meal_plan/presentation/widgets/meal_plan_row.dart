import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/meal_plan/presentation/widgets/food_avatar.dart';

class MealTypeRow extends StatelessWidget {
  final String mealType;
  final List<Map<String, dynamic>> meals;

  const MealTypeRow({super.key, required this.mealType, required this.meals});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: ThemeUtils.$secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(mealType, style: const TextStyle(fontSize: 12)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: meals.map<Widget>((meal) {
                return Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: FoodAvatar(imageUrl: meal['imageUrl'] ?? ''),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
