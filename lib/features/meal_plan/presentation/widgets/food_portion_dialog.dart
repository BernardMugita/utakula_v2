// Add this new file: features/meal_plan/presentation/widgets/food_portion_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/foods/domain/entities/food_entity.dart';

class FoodPortionDialog extends StatefulWidget {
  final FoodEntity food;

  const FoodPortionDialog({super.key, required this.food});

  @override
  State<FoodPortionDialog> createState() => _FoodPortionDialogState();
}

class _FoodPortionDialogState extends State<FoodPortionDialog> {
  final TextEditingController gramsController = TextEditingController(
    text: '100',
  );
  final TextEditingController servingsController = TextEditingController(
    text: '1.0',
  );

  bool _updatingFromGrams = false;
  bool _updatingFromServings = false;

  // Category-based typical serving sizes (from backend logic)
  int get typicalServingGrams {
    final mealType = widget.food.mealType.toString();
    final macroNutrient = widget.food.macroNutrient ?? '';

    if (mealType.contains('beverage')) return 250;
    if (mealType.contains('fruit')) return 120;
    if (mealType.contains('side')) return 100;
    if (macroNutrient == 'Protein') return 150;
    if (macroNutrient == 'Carbohydrate') return 200;
    return 100;
  }

  @override
  void initState() {
    super.initState();
    // Initialize with typical serving
    gramsController.text = typicalServingGrams.toString();
    _updateServingsFromGrams();
  }

  void _updateServingsFromGrams() {
    if (_updatingFromServings) return;
    _updatingFromGrams = true;

    final grams = double.tryParse(gramsController.text) ?? 100;
    final servings = grams / typicalServingGrams;
    servingsController.text = servings.toStringAsFixed(1);

    _updatingFromGrams = false;
    setState(() {});
  }

  void _updateGramsFromServings() {
    if (_updatingFromGrams) return;
    _updatingFromServings = true;

    final servings = double.tryParse(servingsController.text) ?? 1.0;
    final grams = servings * typicalServingGrams;
    gramsController.text = grams.toStringAsFixed(0);

    _updatingFromServings = false;
    setState(() {});
  }

  Map<String, dynamic> _calculateNutrition() {
    final grams = double.tryParse(gramsController.text) ?? 100;
    final servings = double.tryParse(servingsController.text) ?? 1.0;
    final multiplier = grams / 100; // All nutrition is per 100g

    final caloriesTotal = widget.food.calories?.total ?? 0;
    final breakdown = widget.food.calories?.breakDown;

    return {
      'id': widget.food.id,
      'name': widget.food.name,
      'image_url': widget.food.imageUrl,
      'grams': grams,
      'servings': servings,
      'calories_per_100g': caloriesTotal.toDouble(),
      'total_calories': (caloriesTotal * multiplier).toDouble(),
      'macros': {
        'protein_g': ((breakdown?['protein']?.amount ?? 0) * multiplier)
            .toDouble(),
        'carbs_g': ((breakdown?['carbohydrate']?.amount ?? 0) * multiplier)
            .toDouble(),
        'fat_g': ((breakdown?['fat']?.amount ?? 0) * multiplier).toDouble(),
        'fiber_g': ((breakdown?['fiber']?.amount ?? 0) * multiplier).toDouble(),
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    final nutrition = _calculateNutrition();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Food Image & Name
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: ThemeUtils.primaryColor(context).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: widget.food.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            "assets/foods/${widget.food.imageUrl}",
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.fastfood),
                          ),
                        )
                      : const Icon(Icons.fastfood, size: 30),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.food.name ?? 'Unknown',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ThemeUtils.blacks(context),
                        ),
                      ),
                      Text(
                        '${widget.food.calories?.total ?? 0} cal per 100g',
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeUtils.primaryColor(
                            context,
                          ).withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(24),

            // Input Fields
            Row(
              children: [
                // Grams Input
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Grams',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: ThemeUtils.primaryColor(
                            context,
                          ).withOpacity(0.7),
                        ),
                      ),
                      const Gap(6),
                      TextField(
                        controller: gramsController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,1}'),
                          ),
                        ],
                        onChanged: (_) => _updateServingsFromGrams(),
                        decoration: InputDecoration(
                          suffixText: 'g',
                          filled: true,
                          fillColor: ThemeUtils.secondaryColor(context),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(12),

                // Servings Input
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Servings',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: ThemeUtils.primaryColor(
                            context,
                          ).withOpacity(0.7),
                        ),
                      ),
                      const Gap(6),
                      TextField(
                        controller: servingsController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,1}'),
                          ),
                        ],
                        onChanged: (_) => _updateGramsFromServings(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ThemeUtils.secondaryColor(context),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(20),

            // Nutrition Preview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ThemeUtils.primaryColor(context).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Calories',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeUtils.primaryColor(context),
                        ),
                      ),
                      Text(
                        '${nutrition['total_calories'].toStringAsFixed(0)} cal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ThemeUtils.primaryColor(context),
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMacroChip(
                        'P',
                        nutrition['macros']['protein_g'],
                        Colors.red,
                      ),
                      _buildMacroChip(
                        'C',
                        nutrition['macros']['carbs_g'],
                        Colors.blue,
                      ),
                      _buildMacroChip(
                        'F',
                        nutrition['macros']['fat_g'],
                        Colors.amber,
                      ),
                      _buildMacroChip(
                        'Fb',
                        nutrition['macros']['fiber_g'],
                        Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => context.pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, nutrition),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeUtils.primaryColor(context),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Add Food',
                      style: TextStyle(
                        color: ThemeUtils.secondaryColor(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroChip(String label, double grams, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            '${grams.toStringAsFixed(1)}g',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 10, color: color)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    gramsController.dispose();
    servingsController.dispose();
    super.dispose();
  }
}
