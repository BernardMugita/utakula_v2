import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';

class DaysWidget extends StatelessWidget {
  final Map selectedPlan;
  final List myMealPlan;
  final List sharedPlans;

  const DaysWidget({
    Key? key,
    this.selectedPlan = const {},
    this.myMealPlan = const [],
    this.sharedPlans = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              if (selectedPlan.isNotEmpty)
                _buildDayCard(
                  context,
                  Map<String, dynamic>.from(selectedPlan),
                  isExpanded: true,
                )
              else
                for (var plan in myMealPlan)
                  _buildDayCard(
                    context,
                    Map<String, dynamic>.from(plan),
                    isExpanded: false,
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
                          // This will be handled when you add navigation
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
                        // TODO: Navigate to NewMealPlan screen
                        // This will be handled when you add navigation
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

  Widget _buildDayCard(
    BuildContext context,
    Map<String, dynamic> plan, {
    required bool isExpanded,
  }) {
    // TODO: This will be replaced with actual day checking logic
    final bool isActive = false; // Placeholder for day active state
    final String dayName = plan['day'] ?? 'Day';

    return GestureDetector(
      onTap: () {
        // TODO: Handle plan selection
        // This will be handled through Riverpod state management
      },
      child: Container(
        width: isExpanded
            ? double.infinity
            : MediaQuery.of(context).size.width / 4,
        height: isExpanded ? 300 : 100,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive || isExpanded
              ? ThemeUtils.$secondaryColor
              : ThemeUtils.$primaryColor,
          boxShadow: [
            BoxShadow(
              color: ThemeUtils.$blacks.withOpacity(0.3),
              offset: const Offset(5.0, 5.0),
              blurRadius: 10.0,
              spreadRadius: 2.0,
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: isExpanded
            ? _buildExpandedDayContent(context, plan, isActive)
            : _buildCollapsedDayContent(dayName, isActive),
      ),
    );
  }

  Widget _buildExpandedDayContent(
    BuildContext context,
    Map<String, dynamic> plan,
    bool isActive,
  ) {
    final String dayName = plan['day'] ?? 'Day';

    return Column(
      children: [
        // Header with day name and close button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dayName,
              style: TextStyle(
                color: isActive
                    ? ThemeUtils.$primaryColor
                    : ThemeUtils.$primaryColor,
                fontSize: 22,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Reset to default view
                // This will be handled through Riverpod state management
              },
              child: const Icon(
                Icons.fullscreen_exit,
                color: ThemeUtils.$primaryColor,
              ),
            ),
          ],
        ),
        const Gap(10),

        // Meal carousel placeholder
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ThemeUtils.$backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                'Meal carousel will go here',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
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
                    // TODO: Show calorie stats dialog
                  },
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    elevation: const WidgetStatePropertyAll(0),
                    backgroundColor: WidgetStatePropertyAll(
                      ThemeUtils.$blacks.withOpacity(0.1),
                    ),
                  ),
                  child: const Text(
                    "Calorie Stats",
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeUtils.$primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Gap(10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to prepare/how-to screen
                  },
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    elevation: const WidgetStatePropertyAll(0),
                    backgroundColor: const WidgetStatePropertyAll(
                      ThemeUtils.$blacks,
                    ),
                  ),
                  child: const Text(
                    "Prepare",
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeUtils.$secondaryColor,
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

  Widget _buildCollapsedDayContent(String dayName, bool isActive) {
    return Center(
      child: Text(
        dayName.substring(0, 3),
        style: TextStyle(
          color: isActive
              ? ThemeUtils.$primaryColor
              : ThemeUtils.$secondaryColor,
          fontSize: 22,
        ),
      ),
    );
  }
}
