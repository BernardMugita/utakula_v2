import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/foods/data/models/calorie_model.dart';
import 'package:utakula_v2/features/foods/data/models/food_model.dart';
import 'package:utakula_v2/features/foods/domain/entities/food_entity.dart';

class FoodContainer extends HookWidget {
  final FoodEntity foodDetails;

  const FoodContainer({Key? key, required this.foodDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(false);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      // margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: ThemeUtils.secondaryColor(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isExpanded.value
              ? ThemeUtils.primaryColor(context).withOpacity(0.3)
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isExpanded.value
                ? ThemeUtils.primaryColor(context).withOpacity(0.15)
                : Colors.black.withOpacity(0.05),
            blurRadius: isExpanded.value ? 16 : 12,
            offset: Offset(0, isExpanded.value ? 6 : 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            isExpanded.value = !isExpanded.value;
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header Row
                Row(
                  children: [
                    // Food Image
                    Hero(
                      tag: 'food-${foodDetails.name}',
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              ThemeUtils.primaryColor(context).withOpacity(0.1),
                              ThemeUtils.primaryColor(
                                context,
                              ).withOpacity(0.05),
                            ],
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ThemeUtils.primaryColor(
                              context,
                            ).withOpacity(0.2),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: ThemeUtils.primaryColor(
                                context,
                              ).withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child:
                              foodDetails.imageUrl != null &&
                                  foodDetails.imageUrl!.isNotEmpty
                              ? Image.asset(
                                  'assets/foods/${foodDetails.imageUrl}',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      FluentIcons.food_24_filled,
                                      color: ThemeUtils.primaryColor(context),
                                      size: 28,
                                    );
                                  },
                                )
                              : Icon(
                                  FluentIcons.food_24_filled,
                                  color: ThemeUtils.primaryColor(context),
                                  size: 28,
                                ),
                        ),
                      ),
                    ),
                    const Gap(16),

                    // Food Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            foodDetails.name,
                            style: TextStyle(
                              color: ThemeUtils.blacks(context),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Gap(6),
                          Row(
                            children: [
                              // Meal Type Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: ThemeUtils.primaryColor(
                                    context,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Icon(
                                    //   _getMealIcon(foodDetails.mealType),
                                    //   size: 12,
                                    //   color: ThemeUtils.primaryColor(context),
                                    // ),
                                    const Gap(4),
                                    Text(
                                      foodDetails.mealType
                                          .toString()
                                          .split('.')
                                          .last
                                          .replaceAll('_', ' ')
                                          .toUpperCase(),
                                      style: TextStyle(
                                        color: ThemeUtils.primaryColor(context),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(8),
                              // Quick Calories Preview
                              if (foodDetails.calories != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        FluentIcons.fire_24_filled,
                                        size: 12,
                                        color: Colors.deepOrange,
                                      ),
                                      const Gap(4),
                                      Text(
                                        '${foodDetails.calories!.total} cal',
                                        style: const TextStyle(
                                          color: Colors.deepOrange,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Expand/Collapse Button
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 300),
                      turns: isExpanded.value ? 0.5 : 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ThemeUtils.primaryColor(
                            context,
                          ).withOpacity(isExpanded.value ? 0.15 : 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          FluentIcons.chevron_down_24_filled,
                          color: ThemeUtils.primaryColor(context),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),

                // Expanded Content
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    children: [
                      const Gap(16),
                      Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              ThemeUtils.primaryColor(context).withOpacity(0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const Gap(16),
                      _buildNutritionDetails(foodDetails, context),
                    ],
                  ),
                  crossFadeState: isExpanded.value
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionDetails(FoodEntity food, BuildContext context) {
    if (food.calories == null) {
      return _buildErrorMessage(context);
    }

    final breakdown = food.calories!.breakDown;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Total Calories Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.orange.withOpacity(0.15),
                Colors.deepOrange.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.deepOrange.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  FluentIcons.fire_24_filled,
                  color: Colors.deepOrange,
                  size: 28,
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Calories',
                      style: TextStyle(
                        fontSize: 13,
                        color: ThemeUtils.blacks(context).withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      '${food.calories!.total} kcal',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepOrange.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'per 100g',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(20),

        // Macros Breakdown Title
        Row(
          children: [
            Icon(
              FluentIcons.food_24_filled,
              size: 18,
              color: ThemeUtils.primaryColor(context),
            ),
            const Gap(8),
            Text(
              'Macronutrient Breakdown per ${food.referencePortionGrams} grams',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: ThemeUtils.blacks(context),
              ),
            ),
          ],
        ),
        const Gap(12),

        // Macro Cards Grid
        _buildMacroGrid(breakdown, context),
      ],
    );
  }

  Widget _buildMacroGrid(Map<String, dynamic> breakdown, BuildContext context) {
    final macros = [
      {
        'key': 'protein',
        'name': 'Protein',
        'icon': FluentIcons.dumbbell_24_filled,
        'color': Colors.red,
      },
      {
        'key': 'carbohydrate',
        'name': 'Carbs',
        'icon': FluentIcons.food_24_filled,
        'color': Colors.blue,
      },
      {
        'key': 'fat',
        'name': 'Fat',
        'icon': FluentIcons.drop_24_filled,
        'color': Colors.amber,
      },
      {
        'key': 'fiber',
        'name': 'Fiber',
        'icon': FluentIcons.leaf_one_24_filled,
        'color': Colors.green,
      },
    ];

    return Column(
      children: [
        // First Row: Protein & Carbs
        Row(
          children: [
            Expanded(
              child: _buildMacroCard(
                breakdown[macros[0]['key']],
                macros[0]['name'] as String,
                macros[0]['icon'] as IconData,
                macros[0]['color'] as Color,
                context,
              ),
            ),
            const Gap(12),
            Expanded(
              child: _buildMacroCard(
                breakdown[macros[1]['key']],
                macros[1]['name'] as String,
                macros[1]['icon'] as IconData,
                macros[1]['color'] as Color,
                context,
              ),
            ),
          ],
        ),
        const Gap(12),
        // Second Row: Fat & Fiber
        Row(
          children: [
            Expanded(
              child: _buildMacroCard(
                breakdown[macros[2]['key']],
                macros[2]['name'] as String,
                macros[2]['icon'] as IconData,
                macros[2]['color'] as Color,
                context,
              ),
            ),
            const Gap(12),
            Expanded(
              child: _buildMacroCard(
                breakdown[macros[3]['key']],
                macros[3]['name'] as String,
                macros[3]['icon'] as IconData,
                macros[3]['color'] as Color,
                context,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMacroCard(
    NutrientBreakdown data,
    String name,
    IconData icon,
    Color color,
    BuildContext context,
  ) {
    final amount = data.amount ?? 0;
    final unit = data.unit ?? 'g';
    final calories = data.calories ?? 0;

    return Container(
      padding: const EdgeInsets.all(12), // Reduced from 16
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12), // Reduced from 16
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(8), // Reduced from 10
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20), // Reduced from 24
          ),
          const Gap(6), // Reduced from 10
          // Name
          Text(
            name,
            style: TextStyle(
              fontSize: 11, // Reduced from 12
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
          const Gap(4), // Reduced from 6
          // Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                amount.toString(),
                style: TextStyle(
                  fontSize: 16, // Reduced from 20
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const Gap(2),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 10, // Reduced from 12
                  fontWeight: FontWeight.w600,
                  color: color.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const Gap(3), // Reduced from 4
          // Calories
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            // Reduced
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6), // Reduced from 8
            ),
            child: Text(
              '$calories cal',
              style: TextStyle(
                fontSize: 9, // Reduced from 10
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: ThemeUtils.backgroundColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ThemeUtils.$error.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeUtils.$error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              FluentIcons.warning_24_filled,
              color: ThemeUtils.$error,
              size: 36,
            ),
          ),
          const Gap(16),
          const Text(
            "No nutrition data available",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const Gap(6),
          Text(
            "This food item doesn't have nutritional information yet",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ThemeUtils.blacks(context).withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMealIcon(String? mealType) {
    if (mealType == null) return FluentIcons.food_24_regular;

    final type = mealType.toLowerCase();
    if (type.contains('breakfast')) {
      return FluentIcons.weather_sunny_24_filled;
    } else if (type.contains('lunch')) {
      return FluentIcons.food_24_filled;
    } else if (type.contains('supper') || type.contains('dinner')) {
      return FluentIcons.weather_moon_24_filled;
    }
    return FluentIcons.food_24_regular;
  }
}
