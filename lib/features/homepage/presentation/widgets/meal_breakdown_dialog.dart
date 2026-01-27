import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/total_macros.dart';

class MealBreakdownDialog extends StatelessWidget {
  final String mealType;
  final List<Map<String, dynamic>> foods;

  const MealBreakdownDialog({
    super.key,
    required this.mealType,
    required this.foods,
  });

  Map<String, double> _calculateMealMacros() {
    double protein = 0, carbs = 0, fat = 0, fiber = 0, totalCal = 0;

    for (var food in foods) {
      final macros = food['macros'];

      // Handle both Map and TotalMacros formats
      if (macros is Map) {
        protein += (macros['protein_g'] as num?)?.toDouble() ?? 0;
        carbs += (macros['carbs_g'] as num?)?.toDouble() ?? 0;
        fat += (macros['fat_g'] as num?)?.toDouble() ?? 0;
        fiber += (macros['fiber_g'] as num?)?.toDouble() ?? 0;
      } else if (macros is TotalMacros) {
        protein += macros.proteinGrams;
        carbs += macros.carbohydrateGrams;
        fat += macros.fatGrams;
        fiber += macros.fibreGrams;
      }

      totalCal +=
          (food['total_calories'] as num?)?.toDouble() ??
          (food['calories'] as num?)?.toDouble() ??
          0;
    }

    return {
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
      'totalCalories': totalCal,
    };
  }

  @override
  Widget build(BuildContext context) {
    final mealMacros = _calculateMealMacros();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Text(
              '$mealType Breakdown',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ThemeUtils.blacks(context),
              ),
            ),
            const Gap(8),
            Text(
              '${mealMacros['totalCalories']!.toString()} cal',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: ThemeUtils.primaryColor(context),
              ),
            ),
            const Gap(16),

            // Meal Macros
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMacroChip('Protein', mealMacros['protein']!, Colors.red),
                _buildMacroChip('Carbs', mealMacros['carbs']!, Colors.blue),
                _buildMacroChip('Fat', mealMacros['fat']!, Colors.amber),
                _buildMacroChip('Fiber', mealMacros['fiber']!, Colors.green),
              ],
            ),
            const Gap(20),
            Divider(color: ThemeUtils.blacks(context).withOpacity(0.2)),
            const Gap(12),

            // Food List
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  return _buildFoodItem(foods[index], context);
                },
              ),
            ),

            const Gap(16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeUtils.primaryColor(context),
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Close',
                style: TextStyle(color: ThemeUtils.secondaryColor(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroChip(String label, double grams, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '${grams.round().toString()}g',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 10, color: color)),
        ],
      ),
    );
  }

  Widget _buildFoodItem(Map<String, dynamic> food, BuildContext context) {
    final macros = food['macros'];

    // Extract macro values based on type
    double protein = 0, carbs = 0, fat = 0, fiber = 0;
    if (macros is Map) {
      protein = (macros['protein_g'] as num?)?.toDouble() ?? 0;
      carbs = (macros['carbs_g'] as num?)?.toDouble() ?? 0;
      fat = (macros['fat_g'] as num?)?.toDouble() ?? 0;
      fiber = (macros['fiber_g'] as num?)?.toDouble() ?? 0;
    } else if (macros is TotalMacros) {
      protein = macros.proteinGrams;
      carbs = macros.carbohydrateGrams;
      fat = macros.fatGrams;
      fiber = macros.fibreGrams;
    }

    final calories =
        (food['total_calories'] ?? food['calories'] as num?)?.toDouble() ?? 0;
    final grams = (food['grams'] as num?)?.toDouble() ?? 0;
    final servings = (food['servings'] as num?)?.toDouble() ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeUtils.backgroundColor(context),
        border: Border.all(color: ThemeUtils.blacks(context).withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: ThemeUtils.primaryColor(context),
              shape: BoxShape.circle,
            ),
          ),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food['name'] ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(4),
                Row(
                  children: [
                    _buildInfoTag('${grams.toStringAsFixed(0)}g', Colors.blue),
                    const Gap(6),
                    _buildInfoTag(
                      '${servings.toStringAsFixed(1)} servings',
                      Colors.purple,
                    ),
                  ],
                ),
                const Gap(6),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    _buildMacroTag(
                      'P: ${protein.toStringAsFixed(1)}g',
                      Colors.red,
                    ),
                    _buildMacroTag(
                      'C: ${carbs.toStringAsFixed(1)}g',
                      Colors.blue,
                    ),
                    _buildMacroTag(
                      'F: ${fat.toStringAsFixed(1)}g',
                      Colors.amber,
                    ),
                    _buildMacroTag(
                      'Fb: ${fiber.toStringAsFixed(1)}g',
                      Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${calories.toStringAsFixed(0)} cal',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: ThemeUtils.primaryColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMacroTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
