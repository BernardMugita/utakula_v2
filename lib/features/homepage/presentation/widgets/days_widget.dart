import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/homepage/presentation/providers/homepage_providers.dart';
import 'package:utakula_v2/features/homepage/presentation/widgets/day_item.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/day_meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/meal_plan_entity.dart';

class DaysWidget extends HookConsumerWidget {
  final DayMealPlanEntity? selectedPlan;
  final MealPlanEntity myMealPlan;
  final List sharedPlans;

  const DaysWidget({
    super.key,
    required this.selectedPlan,
    required this.myMealPlan,
    required this.sharedPlans,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homePageState = ref.watch(homepageStateProvider);
    final homepageNotifier = ref.read(homepageStateProvider.notifier);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeUtils.secondaryColor(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Days display area - FIXED GRID LAYOUT
          if (homePageState.isExpanded && selectedPlan != null)
            DayItem(plan: selectedPlan!, isExpanded: true, isActive: true)
          else
            _buildDaysGrid(context, myMealPlan, homepageNotifier),

          const Gap(20),

          // Bottom action buttons
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (sharedPlans.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          // TODO: Navigate to MemberMealPlans screen
                        },
                        style: ButtonStyle(
                          side: WidgetStatePropertyAll(
                            BorderSide(color: ThemeUtils.primaryColor(context)),
                          ),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          padding: const WidgetStatePropertyAll(
                            EdgeInsets.only(
                              top: 5,
                              bottom: 5,
                              left: 10,
                              right: 10,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Member meal Plans",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: ThemeUtils.blacks(context),
                              ),
                            ),
                            const Gap(10),
                            CircleAvatar(
                              backgroundColor: ThemeUtils.blacks(
                                context,
                              ).withOpacity(0.1),
                              child: Icon(
                                FluentIcons.people_24_regular,
                                size: 16,
                                color: ThemeUtils.primaryColor(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        child: Text(
                          "Your shared meal plans",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          '/new-meal-plan',
                          extra: {'userMealPlan': myMealPlan},
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: ThemeUtils.blacks(
                          context,
                        ).withOpacity(0.1),
                        child: Icon(
                          Icons.edit,
                          color: ThemeUtils.primaryColor(context),
                        ),
                      ),
                    ),
                    const Gap(5),
                    const SizedBox(
                      child: Text(
                        "Edit",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a proper 3-column grid for the 7 days
  Widget _buildDaysGrid(
    BuildContext context,
    MealPlanEntity myMealPlan,
    dynamic homepageNotifier,
  ) {
    // Calculate item width accounting for padding and spacing
    final screenWidth = MediaQuery.of(context).size.width;
    final containerPadding = 90.0; // 20px padding on each side
    final totalSpacing = 10.0; // 2 gaps of 5px each for 3 columns
    final availableWidth = screenWidth - containerPadding - totalSpacing;
    final itemWidth = availableWidth / 3;

    return Column(
      spacing: 5,
      children: [
        // First row: 3 items
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < 3 && i < myMealPlan.mealPlan.length; i++)
              SizedBox(
                width: itemWidth,
                child: DayItem(
                  plan: myMealPlan.mealPlan[i],
                  isExpanded: false,
                  isActive: homepageNotifier.isDayActive(
                    myMealPlan.mealPlan[i].day,
                  ),
                ),
              ),
          ],
        ),
        const Gap(5),
        // Second row: 3 items
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 3; i < 6 && i < myMealPlan.mealPlan.length; i++)
              SizedBox(
                width: itemWidth,
                child: DayItem(
                  plan: myMealPlan.mealPlan[i],
                  isExpanded: false,
                  isActive: homepageNotifier.isDayActive(
                    myMealPlan.mealPlan[i].day,
                  ),
                ),
              ),
          ],
        ),
        const Gap(5),
        // Third row: 1 item (Sunday), centered
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (myMealPlan.mealPlan.length > 6)
              SizedBox(
                width: itemWidth,
                child: DayItem(
                  plan: myMealPlan.mealPlan[6],
                  isExpanded: false,
                  isActive: homepageNotifier.isDayActive(
                    myMealPlan.mealPlan[6].day,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
