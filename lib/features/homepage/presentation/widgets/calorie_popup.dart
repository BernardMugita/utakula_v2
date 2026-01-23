import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/day_meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/single_meal_plan_entity.dart';

class CaloriePopup extends StatelessWidget {
  final DayMealPlanEntity selectedPlan;

  const CaloriePopup({super.key, required this.selectedPlan});

  double _calculateMealCalories(List<MealTypeFoodEntity> foods) {
    return foods.fold(
      0.0,
          (sum, food) => sum + food.calories,
    );
  }

  @override
  Widget build(BuildContext context) {
    final breakfastCalories = _calculateMealCalories(
      selectedPlan.mealPlan.breakfast,
    );
    final lunchCalories = _calculateMealCalories(selectedPlan.mealPlan.lunch);
    final supperCalories = _calculateMealCalories(selectedPlan.mealPlan.supper);
    final totalCalories = selectedPlan.totalCalories;
    final totalMacros = selectedPlan.totalMacros;

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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ThemeUtils.$primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    selectedPlan.day,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: ThemeUtils.$primaryColor,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    '${totalCalories.toStringAsFixed(0)} cal',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: ThemeUtils.$blacks,
                    ),
                  ),
                  const Gap(12),
                  // Daily Macros Summary
                  _buildDailyMacrosSummary(totalMacros),
                ],
              ),
            ),
            const Gap(20),

            // Meal Breakdown Title
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: ThemeUtils.$primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Gap(8),
                const Text(
                  'Meal Breakdown',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ThemeUtils.$blacks,
                  ),
                ),
              ],
            ),
            const Gap(12),

            // Breakfast
            _buildMealSection(
              'Breakfast',
              selectedPlan.mealPlan.breakfast,
              breakfastCalories,
              totalCalories,
              Icons.wb_sunny_outlined,
              Colors.orange,
            ),
            const Gap(12),

            // Lunch
            _buildMealSection(
              'Lunch',
              selectedPlan.mealPlan.lunch,
              lunchCalories,
              totalCalories,
              Icons.restaurant_outlined,
              Colors.green,
            ),
            const Gap(12),

            // Supper
            _buildMealSection(
              'Supper',
              selectedPlan.mealPlan.supper,
              supperCalories,
              totalCalories,
              Icons.dinner_dining_outlined,
              Colors.deepPurple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyMacrosSummary(dynamic totalMacros) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMacroChip(
          'Protein',
          totalMacros.proteinGrams,
          Colors.red.shade100,
          Colors.red.shade700,
        ),
        _buildMacroChip(
          'Carbs',
          totalMacros.carbohydrateGrams,
          Colors.blue.shade100,
          Colors.blue.shade700,
        ),
        _buildMacroChip(
          'Fat',
          totalMacros.fatGrams,
          Colors.amber.shade100,
          Colors.amber.shade700,
        ),
        _buildMacroChip(
          'Fiber',
          totalMacros.fibreGrams,
          Colors.green.shade100,
          Colors.green.shade700,
        ),
      ],
    );
  }

  Widget _buildMacroChip(
      String label,
      double grams,
      Color bgColor,
      Color textColor,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            '${grams.toStringAsFixed(1)}g',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: textColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealSection(
      String mealName,
      List<MealTypeFoodEntity> foods,
      double calories,
      double totalCalories,
      IconData icon,
      Color color,
      ) {
    if (foods.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          '$mealName: No items',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      );
    }

    final percentage = totalCalories > 0
        ? (calories / totalCalories * 100).toStringAsFixed(0)
        : '0';

    // Calculate meal macros
    final mealMacros = _calculateMealMacros(foods);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Meal Header
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mealName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        '${foods.length} item${foods.length > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 12,
                          color: color.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${calories.toStringAsFixed(0)} cal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$percentage%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Meal Macros Summary
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMiniMacro('P', mealMacros['protein']!, Colors.red),
                _buildMiniMacro('C', mealMacros['carbs']!, Colors.blue),
                _buildMiniMacro('F', mealMacros['fat']!, Colors.amber),
                _buildMiniMacro('Fb', mealMacros['fiber']!, Colors.green),
              ],
            ),
          ),

          // Food Items
          ...foods.asMap().entries.map((entry) {
            final index = entry.key;
            final food = entry.value;
            final isLast = index == foods.length - 1;

            return _buildFoodItem(food, color, isLast);
          }),
        ],
      ),
    );
  }

  Map<String, double> _calculateMealMacros(List<MealTypeFoodEntity> foods) {
    double protein = 0, carbs = 0, fat = 0, fiber = 0;

    for (var food in foods) {
      protein += food.macros.proteinGrams;
      carbs += food.macros.carbohydrateGrams;
      fat += food.macros.fatGrams;
      fiber += food.macros.fibreGrams;
    }

    return {
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
    };
  }

  Widget _buildMiniMacro(String label, double grams, Color color) {
    return Column(
      children: [
        Text(
          '${grams.toStringAsFixed(1)}g',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildFoodItem(
      MealTypeFoodEntity food,
      Color accentColor,
      bool isLast,
      ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
          bottom: BorderSide(color: Colors.grey.shade100),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food name and calories
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
              ),
              const Gap(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.foodName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ThemeUtils.$blacks,
                      ),
                    ),
                    const Gap(6),
                    // Grams and Servings
                    Row(
                      children: [
                        _buildInfoPill(
                          '${food.grams.toStringAsFixed(0)}g',
                          Icons.scale_outlined,
                          Colors.blue.shade100,
                          Colors.blue.shade700,
                        ),
                        const Gap(6),
                        _buildInfoPill(
                          '${food.servings.toStringAsFixed(1)} serving${food.servings > 1 ? 's' : ''}',
                          Icons.restaurant_menu_outlined,
                          Colors.purple.shade100,
                          Colors.purple.shade700,
                        ),
                      ],
                    ),
                    const Gap(8),
                    // Macros breakdown
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _buildMacroTag(
                          'P: ${food.macros.proteinGrams.toStringAsFixed(1)}g',
                          Colors.red.shade50,
                          Colors.red.shade700,
                        ),
                        _buildMacroTag(
                          'C: ${food.macros.carbohydrateGrams.toStringAsFixed(1)}g',
                          Colors.blue.shade50,
                          Colors.blue.shade700,
                        ),
                        _buildMacroTag(
                          'F: ${food.macros.fatGrams.toStringAsFixed(1)}g',
                          Colors.amber.shade50,
                          Colors.amber.shade700,
                        ),
                        _buildMacroTag(
                          'Fb: ${food.macros.fibreGrams.toStringAsFixed(1)}g',
                          Colors.green.shade50,
                          Colors.green.shade700,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(12),
              // Calories
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      '${food.calories.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                    Text(
                      'cal',
                      style: TextStyle(
                        fontSize: 10,
                        color: accentColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPill(
      String text,
      IconData icon,
      Color bgColor,
      Color textColor,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const Gap(4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}