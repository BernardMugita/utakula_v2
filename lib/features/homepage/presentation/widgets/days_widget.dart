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
        color: ThemeUtils.$secondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Days display area
          Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            runSpacing: 5,
            spacing: 5,
            children: [
              if (homePageState.isExpanded && selectedPlan != null)
                DayItem(plan: selectedPlan!, isExpanded: true, isActive: true)
              else
                for (var plan in myMealPlan.mealPlan)
                  DayItem(
                    plan: plan,
                    isExpanded: false,
                    isActive: homepageNotifier.isDayActive(plan.day),
                  ),
            ],
          ),

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
                          side: const WidgetStatePropertyAll(
                            BorderSide(color: ThemeUtils.$primaryColor),
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
                            const Text(
                              "Member meal Plans",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: ThemeUtils.$blacks,
                              ),
                            ),
                            const Gap(10),
                            CircleAvatar(
                              backgroundColor: ThemeUtils.$blacks.withOpacity(
                                0.1,
                              ),
                              child: const Icon(
                                FluentIcons.people_24_regular,
                                size: 16,
                                color: ThemeUtils.$primaryColor,
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
                        backgroundColor: ThemeUtils.$blacks.withOpacity(0.1),
                        child: const Icon(
                          Icons.edit,
                          color: ThemeUtils.$primaryColor,
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
}
