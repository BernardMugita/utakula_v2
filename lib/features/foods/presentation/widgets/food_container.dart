import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
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
      decoration: BoxDecoration(
        color: ThemeUtils.$secondaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
                Row(
                  children: [
                    Hero(
                      tag: 'food-${foodDetails.name}',
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: ThemeUtils.$backgroundColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ThemeUtils.$primaryColor.withOpacity(0.1),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: ThemeUtils.$primaryColor.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: foodDetails.imageUrl != null &&
                                  foodDetails.imageUrl!.isNotEmpty
                              ? Image.network(
                                  foodDetails.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      FluentIcons.food_24_regular,
                                      color: ThemeUtils.$primaryColor,
                                    );
                                  },
                                )
                              : const Icon(
                                  FluentIcons.food_24_regular,
                                  color: ThemeUtils.$primaryColor,
                                ),
                        ),
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            foodDetails.name,
                            style: const TextStyle(
                              color: ThemeUtils.$primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Gap(4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeUtils.$primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              foodDetails.mealType
                                  .toString()
                                  .split('.')
                                  .last
                                  .replaceAll('_', ' ')
                                  .toUpperCase(),
                              style: TextStyle(
                                color: ThemeUtils.$primaryColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 300),
                      turns: isExpanded.value ? 0.5 : 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ThemeUtils.$primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          FluentIcons.chevron_down_24_regular,
                          color: ThemeUtils.$primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    children: [
                      const Gap(16),
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              ThemeUtils.$primaryColor.withOpacity(0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const Gap(16),
                      _buildCalorieDetails(foodDetails),
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

  Widget _buildCalorieDetails(FoodEntity food) {
    if (food.calories == null) {
      return _buildErrorMessage();
    }

    final breakdown = food.calories!.breakdown;

    if (breakdown.isEmpty) {
      return _buildErrorMessage();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeUtils.$backgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withOpacity(0.1),
                  Colors.deepOrange.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      FluentIcons.fire_24_filled,
                      color: Colors.deepOrange,
                      size: 24,
                    ),
                    Gap(12),
                    Text(
                      "Total Calories",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepOrange.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    "${food.calories!.total} cal",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Nutritional Breakdown",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          const Gap(12),
          _buildNutrientTable(breakdown),
        ],
      ),
    );
  }

  Widget _buildNutrientTable(Map<String, dynamic> breakdown) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeUtils.$backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeUtils.$primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: ThemeUtils.$primaryColor.withOpacity(0.15),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Nutrient",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Amount",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Unit",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Cal",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          // Rows
          ...breakdown.keys.toList().asMap().entries.map((entry) {
            final index = entry.key;
            final nutrient = entry.value;
            final data = breakdown[nutrient];

            if (data == null || data is! Map) {
              return const SizedBox.shrink();
            }

            final isLast = index == breakdown.length - 1;

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: index.isEven
                    ? Colors.transparent
                    : ThemeUtils.$primaryColor.withOpacity(0.03),
                borderRadius: isLast
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      nutrient.toString().replaceAll('_', ' ').toUpperCase(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      data['amount']?.toString() ?? '-',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      data['unit']?.toString() ?? '-',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      data['calories']?.toString() ?? '-',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ThemeUtils.$backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeUtils.$error.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ThemeUtils.$error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              FluentIcons.error_circle_24_filled,
              color: ThemeUtils.$error,
              size: 32,
            ),
          ),
          const Gap(12),
          const Text(
            "No calorie data available",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const Gap(4),
          Text(
            "Try again later",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ThemeUtils.$primaryColor.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
