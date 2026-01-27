import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/homepage/presentation/providers/homepage_providers.dart';
import 'package:utakula_v2/features/homepage/presentation/widgets/calorie_popup.dart';
import 'package:utakula_v2/features/homepage/presentation/widgets/meal_carousel_card.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/day_meal_plan_entity.dart';

class DayItem extends HookConsumerWidget {
  final DayMealPlanEntity plan;
  final bool isExpanded;
  final bool isActive;

  const DayItem({
    super.key,
    required this.plan,
    required this.isExpanded,
    required this.isActive,
  });

  /// Determines the initial page (0 = breakfast, 1 = lunch, 2 = supper) based on the time of day.
  int _getInitialPageBasedOnTime() {
    final now = TimeOfDay.now();
    if (now.hour < 11) {
      return 0; // Breakfast
    } else if (now.hour < 14) {
      return 1; // Lunch
    } else {
      return 2; // Supper
    }
  }

  /// Check if this day is the current day
  bool _isCurrentDay() {
    final daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final currentDayIndex = DateTime.now().weekday - 1;
    return plan.day == daysOfWeek[currentDayIndex];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homepageNotifier = ref.read(homepageStateProvider.notifier);
    final initialPage = useState(_getInitialPageBasedOnTime());
    final isCurrentDay = _isCurrentDay();

    return GestureDetector(
      onTap: () {
        if (!isExpanded) {
          homepageNotifier.toggleExpansion(plan);
        }
      },
      child: Container(
        width: isExpanded ? double.infinity : double.infinity,
        // CHANGED: Let parent control width
        height: isExpanded ? 300 : 100,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isCurrentDay || isExpanded
              ? ThemeUtils.secondaryColor(context)
              : ThemeUtils.primaryColor(context),
          boxShadow: [
            BoxShadow(
              color: ThemeUtils.boxShadowColor(context).withOpacity(0.1),
              offset: const Offset(5.0, 5.0),
              blurRadius: 10.0,
              spreadRadius: 2.0,
            ),
          ],
          border: Border.all(color: ThemeUtils.blacks(context).withOpacity(0.3), width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: isExpanded
            ? _buildExpandedContent(context, ref, initialPage.value)
            : _buildCollapsedContent(isCurrentDay, context),
      ),
    );
  }

  Widget _buildExpandedContent(
    BuildContext context,
    WidgetRef ref,
    int initialPage,
  ) {
    final homepageNotifier = ref.read(homepageStateProvider.notifier);
    final isCurrentDay = _isCurrentDay();

    // Create sorted meals map
    final mealsMap = {
      'BREAKFAST': plan.mealPlan.breakfast,
      'LUNCH': plan.mealPlan.lunch,
      'SUPPER': plan.mealPlan.supper,
    };

    return Column(
      children: [
        // Header with day name and close button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              plan.day,
              style: TextStyle(
                color: isCurrentDay
                    ? ThemeUtils.primaryColor(context)
                    : ThemeUtils.primaryColor(context),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                homepageNotifier.collapseView();
              },
              child: Icon(
                Icons.fullscreen_exit,
                color: ThemeUtils.primaryColor(context),
              ),
            ),
          ],
        ),
        const Gap(10),

        // Meal Carousel
        Expanded(
          child: CarouselSlider(
            options: CarouselOptions(
              initialPage: initialPage,
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              height: double.infinity,
            ),
            items: mealsMap.entries.map<Widget>((mealEntry) {
              return MealCarouselCard(
                mealType: mealEntry.key,
                foods: mealEntry.value,
              );
            }).toList(),
          ),
        ),
        const Gap(10),

        // Action buttons
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _showCalorieStatsDialog(context);
                  },
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    elevation: const WidgetStatePropertyAll(0),
                    backgroundColor: WidgetStatePropertyAll(
                      ThemeUtils.blacks(context).withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    "Calorie Stats",
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeUtils.primaryColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Gap(10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // context.pushNamed(
                    //   '/how-to-prepare',
                    //   extra: {"selectedPlan": plan},
                    // );
                  },
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    elevation: const WidgetStatePropertyAll(0),
                    backgroundColor: WidgetStatePropertyAll(
                      ThemeUtils.blacks(context),
                    ),
                  ),
                  child: Text(
                    "Prepare",
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeUtils.secondaryColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCollapsedContent(bool isCurrentDay, BuildContext context) {
    return Center(
      child: Text(
        plan.day.length >= 3 ? plan.day.substring(0, 3) : plan.day,
        style: TextStyle(
          color: isCurrentDay
              ? ThemeUtils.primaryColor(context)
              : ThemeUtils.secondaryColor(context),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _showCalorieStatsDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Calorie Stats',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: ThemeUtils.primaryColor(context),
            ),
          ),
          content: CaloriePopup(selectedPlan: plan),
          actions: <Widget>[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: WidgetStatePropertyAll(
                    ThemeUtils.primaryColor(context),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close',
                  style: TextStyle(color: ThemeUtils.secondaryColor(context)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
