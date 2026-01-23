import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/meal_plan/presentation/widgets/meal_plan_row.dart';
import 'package:utakula_v2/routing/routes.dart';

class DayCard extends StatelessWidget {
  final String day;
  final Map<dynamic, dynamic> meals;
  final double totalCalories;
  final bool hasError;
  final Function(Map<dynamic, dynamic> meals, int calories) onUpdate;

  const DayCard({
    super.key,
    required this.day,
    required this.meals,
    required this.totalCalories,
    this.hasError = false,
    required this.onUpdate,
  });

  Color _getDashColor() {
    if (meals.isNotEmpty) {
      return const Color(0xFF00BA06); // Green for completed
    } else if (hasError) {
      return const Color(0xFF8F3131); // Red for error
    } else {
      return ThemeUtils.$blacks.withOpacity(0.3); // Gray for empty
    }
  }

  void _navigateToEditDay(BuildContext context) {
    context.push(
      "${Routes.newPlan}${Routes.dayMealPlan}",
      extra: {
        "day": day,
        "meals": meals,
        "totalCalories": totalCalories,
        "onSave": onUpdate, // Changed from onUpdate to onSave to match router
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 12,
              color: ThemeUtils.$primaryColor,
            ),
          ),
          const Gap(10),
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Dotted border container
              DottedBorder(
                options: CustomPathDottedBorderOptions(
                  padding: const EdgeInsets.all(8),
                  color: _getDashColor(),
                  strokeWidth: 2,
                  dashPattern: [10, 5],
                  customPath: (size) => Path()
                    ..moveTo(0, size.height)
                    ..relativeLineTo(size.width, 0),
                ),
                child: Container(
                  width: double.infinity,
                  height: 190,
                  decoration: BoxDecoration(
                    color: ThemeUtils.$blacks.withOpacity(0.1),
                  ),
                  child: Center(
                    child: meals.isEmpty
                        ? _buildAddButton(context)
                        : _buildMealContent(),
                  ),
                ),
              ),
              // Edit button overlay (only show when meals exist)
              if (meals.isNotEmpty) _buildEditButton(context),
            ],
          ),
        ],
      ),
    );
  }

  // Build add button for empty meal days
  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToEditDay(context),
      child: const CircleAvatar(
        backgroundColor: ThemeUtils.$backgroundColor,
        child: Icon(
          FluentIcons.add_24_regular,
          size: 20,
          color: ThemeUtils.$primaryColor,
        ),
      ),
    );
  }

  // Build meal content when meals exist
  Widget _buildMealContent() {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          // Meal types list
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: meals.entries
                    .map<Widget>(
                      (entry) => MealTypeRow(
                        mealType: entry.key,
                        meals: List<Map<String, dynamic>>.from(entry.value),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          // Total calories badge
          _buildCaloriesBadge(),
        ],
      ),
    );
  }

  // Build calories badge at the bottom
  Widget _buildCaloriesBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: ThemeUtils.$primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                FluentIcons.fire_24_filled,
                size: 14,
                color: ThemeUtils.$secondaryColor,
              ),
            ],
          ),
          Text(
            "$totalCalories cal",
            style: const TextStyle(
              fontSize: 14,
              color: ThemeUtils.$secondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // Build edit button overlay
  Widget _buildEditButton(BuildContext context) {
    return Positioned(
      top: -10,
      right: -10,
      child: GestureDetector(
        onTap: () => _navigateToEditDay(context),
        child: const CircleAvatar(
          radius: 20,
          backgroundColor: ThemeUtils.$backgroundColor,
          child: Icon(FluentIcons.edit_28_regular, size: 20),
        ),
      ),
    );
  }
}
