import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/single_meal_plan_entity.dart';

class MealCarouselCard extends StatelessWidget {
  final String mealType;
  final List<MealTypeFoodEntity> foods;

  const MealCarouselCard({
    super.key,
    required this.mealType,
    required this.foods,
  });

  String _getFullMealName() {
    if (foods.isEmpty) return 'No items';
    if (foods.length == 1) return foods[0].foodName;
    if (foods.length == 2) {
      return '${foods[0].foodName} & ${foods[1].foodName}';
    }

    // For 3 or more items
    final firstTwo = foods.take(2).map((f) => f.foodName).join(', ');
    return '$firstTwo & ${foods.length - 2} more';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ThemeUtils.$backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Meal Title
          SizedBox(
            width: double.infinity,
            child: Text(
              mealType,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: ThemeUtils.$blacks,
              ),
            ),
          ),
          const Divider(),

          // Food Images
          Expanded(
            child: foods.isEmpty
                ? const Center(
                    child: Text(
                      'No items for this meal',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: foods.map((food) {
                      return _buildFoodImage(food);
                    }).toList(),
                  ),
          ),
          const Gap(10),

          // Meal Names
          SizedBox(
            width: double.infinity,
            child: Text(
              _getFullMealName(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodImage(MealTypeFoodEntity food) {
    return Align(
      widthFactor: 0.5,
      child: Image.asset(
        'assets/foods/${food.imageUrl}',
        height: 100,
        width: 100,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(FluentIcons.food_24_regular, size: 15);
        },
      ),
    );
  }
}
