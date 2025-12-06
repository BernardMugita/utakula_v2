import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/day_meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/single_meal_plan_entity.dart';

class CaloriePopup extends StatelessWidget {
  final DayMealPlanEntity selectedPlan;

  const CaloriePopup({
    super.key,
    required this.selectedPlan,
  });

  int _calculateMealCalories(List<MealTypeFoodEntity> foods) {
    return foods.fold(0, (sum, food) => sum + food.calories);
  }

  @override
  Widget build(BuildContext context) {
    final breakfastCalories = _calculateMealCalories(selectedPlan.mealPlan.breakfast);
    final lunchCalories = _calculateMealCalories(selectedPlan.mealPlan.lunch);
    final supperCalories = _calculateMealCalories(selectedPlan.mealPlan.supper);
    final totalCalories = selectedPlan.totalCalories;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ThemeUtils.$primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    selectedPlan.day,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ThemeUtils.$primaryColor,
                    ),
                  ),
                  const Gap(5),
                  Text(
                    'Total: $totalCalories cal',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ThemeUtils.$blacks,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),

            // Breakdown by Meal
            _buildMealCalorieRow('Breakfast', breakfastCalories, totalCalories),
            const Gap(12),
            _buildMealCalorieRow('Lunch', lunchCalories, totalCalories),
            const Gap(12),
            _buildMealCalorieRow('Supper', supperCalories, totalCalories),
            const Gap(20),

            // Detailed breakdown
            const Text(
              'Detailed Breakdown',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ThemeUtils.$primaryColor,
              ),
            ),
            const Gap(10),
            _buildDetailedBreakdown('Breakfast', selectedPlan.mealPlan.breakfast),
            const Gap(8),
            _buildDetailedBreakdown('Lunch', selectedPlan.mealPlan.lunch),
            const Gap(8),
            _buildDetailedBreakdown('Supper', selectedPlan.mealPlan.supper),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCalorieRow(String mealName, int calories, int total) {
    final percentage = total > 0 ? (calories / total * 100).toStringAsFixed(1) : '0.0';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              mealName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '$calories cal',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ThemeUtils.$primaryColor,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: ThemeUtils.$primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                '$percentage%',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedBreakdown(String mealName, List<MealTypeFoodEntity> foods) {
    if (foods.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(8),
        child: Text(
          '$mealName: No items',
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mealName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: ThemeUtils.$primaryColor,
            ),
          ),
          const Gap(5),
          ...foods.map(
                (food) => Padding(
              padding: const EdgeInsets.only(left: 8, top: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '• ${food.foodName}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Text(
                    '${food.calories} cal',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}