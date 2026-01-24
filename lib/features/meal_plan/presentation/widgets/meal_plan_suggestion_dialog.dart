import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/common/helpers/helper_utils.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/account/presentation/providers/user_metrics_provider.dart';
import 'package:utakula_v2/features/meal_plan/data/enums/meal_plan_enums.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/presentation/providers/meal_plan_provider.dart';

class MealPlanSuggestionDialog extends HookConsumerWidget {
  const MealPlanSuggestionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsState = ref.watch(userMetricsStateProvider);
    final bodyGoal = useState<BodyGoal?>(null);
    final useCustomCalories = useState(false);
    final calorieTarget = useState<int>(2000);
    final selectedRestrictions = useState<Set<DietaryRestriction>>({});
    final selectedAllergies = useState<Set<FoodAllergy>>({});
    final selectedConditions = useState<Set<MedicalDietaryCondition>>({});
    final isLoading = useState(false);

    HelperUtils helperUtils = HelperUtils();

    // Get TDEE from user metrics
    final userTdee = metricsState.userMetrics?.calculatedTDEE?.toInt() ?? 2000;
    final hasTdee = metricsState.hasMetrics && userTdee > 0;

    // Initialize calorie target with TDEE if available
    useEffect(() {
      if (hasTdee && !useCustomCalories.value) {
        calorieTarget.value = userTdee;
      }
      return null;
    }, [hasTdee]);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 550,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: ThemeUtils.$secondaryColor,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ThemeUtils.$primaryColor,
                    ThemeUtils.$primaryColor.withOpacity(0.9),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      FluentIcons.sparkle_24_filled,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const Gap(12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Get Your Perfect Meal Plan',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Gap(4),
                        Text(
                          'Personalized just for you',
                          style: TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      FluentIcons.dismiss_24_filled,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Body Goal Section
                    _SectionHeader(
                      icon: FluentIcons.target_24_filled,
                      title: "What's Your Goal?",
                      isRequired: true,
                    ),
                    const Gap(12),
                    _BodyGoalSelector(
                      selectedGoal: bodyGoal.value,
                      onChanged: (goal) => bodyGoal.value = goal,
                    ),
                    const Gap(24),

                    // Calorie Target Section with TDEE Integration
                    _SectionHeader(
                      icon: FluentIcons.fire_24_filled,
                      title: 'Daily Calorie Target',
                    ),
                    const Gap(12),
                    _CalorieTargetSelector(
                      hasTdee: hasTdee,
                      userTdee: userTdee,
                      useCustomCalories: useCustomCalories.value,
                      calorieTarget: calorieTarget.value,
                      onToggleCustom: (value) {
                        useCustomCalories.value = value;
                        if (!value && hasTdee) {
                          calorieTarget.value = userTdee;
                        }
                      },
                      onChanged: (value) => calorieTarget.value = value,
                    ),
                    const Gap(24),

                    // Dietary Restrictions Section
                    _SectionHeader(
                      icon: FluentIcons.leaf_one_24_filled,
                      title: 'Dietary Preferences',
                    ),
                    const Gap(12),
                    _MultiSelectChips<DietaryRestriction>(
                      options: DietaryRestriction.values,
                      selectedOptions: selectedRestrictions.value,
                      onChanged: (restrictions) =>
                          selectedRestrictions.value = restrictions,
                      getDisplay: (item) => item.display,
                    ),
                    const Gap(24),

                    // Allergies Section
                    _SectionHeader(
                      icon: FluentIcons.shield_error_24_filled,
                      title: 'Food Allergies',
                    ),
                    const Gap(12),
                    _MultiSelectChips<FoodAllergy>(
                      options: FoodAllergy.values,
                      selectedOptions: selectedAllergies.value,
                      onChanged: (allergies) =>
                          selectedAllergies.value = allergies,
                      getDisplay: (item) => item.display,
                    ),
                    const Gap(24),

                    // Medical Conditions Section
                    _SectionHeader(
                      icon: FluentIcons.heart_pulse_24_filled,
                      title: 'Health Considerations',
                    ),
                    const Gap(12),
                    _MultiSelectChips<MedicalDietaryCondition>(
                      options: MedicalDietaryCondition.values,
                      selectedOptions: selectedConditions.value,
                      onChanged: (conditions) =>
                          selectedConditions.value = conditions,
                      getDisplay: (item) => item.display,
                    ),
                  ],
                ),
              ),
            ),

            // Action Buttons (Fixed at bottom)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isLoading.value
                          ? null
                          : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ThemeUtils.$primaryColor,
                        side: BorderSide(
                          color: ThemeUtils.$primaryColor.withOpacity(0.5),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: isLoading.value || bodyGoal.value == null
                          ? null
                          : () {
                              _handleSuggestMealPlan(
                                context,
                                bodyGoal.value!,
                                calorieTarget.value,
                                selectedRestrictions.value,
                                selectedAllergies.value,
                                selectedConditions.value,
                                isLoading,
                                ref,
                                helperUtils,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeUtils.$primaryColor,
                        foregroundColor: ThemeUtils.$secondaryColor,
                        disabledBackgroundColor: ThemeUtils.$primaryColor
                            .withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  ThemeUtils.$secondaryColor,
                                ),
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(FluentIcons.wand_24_regular, size: 20),
                                Gap(8),
                                Text(
                                  'Generate Plan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSuggestMealPlan(
    BuildContext context,
    BodyGoal bodyGoal,
    int calorieTarget,
    Set<DietaryRestriction> restrictions,
    Set<FoodAllergy> allergies,
    Set<MedicalDietaryCondition> conditions,
    ValueNotifier<bool> isLoading,
    WidgetRef ref,
    HelperUtils helperUtils,
  ) async {
    isLoading.value = true;
    Logger logger = Logger();

    final requestBody = {
      'body_goal': bodyGoal.value,
      'dietary_restrictions': restrictions.map((r) => r.value).toList(),
      'allergies': allergies.map((a) => a.value).toList(),
      'daily_calorie_target': calorieTarget,
      'medical_conditions': conditions.map((c) => c.value).toList(),
    };

    try {
      final notifier = ref.read(mealPlanStateProvider.notifier);
      final userMealPlanPrefs = helperUtils.convertUserPrefsToEntity(
        requestBody,
      );

      final MealPlanEntity? suggestedMealPlan = await notifier.suggestMealPlan(
        userMealPlanPrefs,
      );

      if (suggestedMealPlan != null) {
        if (context.mounted) {
          logger.i('Suggested meal plan received: ${suggestedMealPlan.id}');
          helperUtils.showSnackBar(
            context,
            'Meal plan suggested successfully!',
            ThemeUtils.$success,
          );
          Navigator.of(context).pop(suggestedMealPlan);
        }
      } else {
        if (context.mounted) {
          final errorMessage =
              ref.read(mealPlanStateProvider).errorMessage ??
              'Failed to suggest meal plan.';
          helperUtils.showSnackBar(context, errorMessage, ThemeUtils.$error);
        }
      }
    } catch (e) {
      logger.e('Error suggesting meal plan: $e');
      if (context.mounted) {
        helperUtils.showSnackBar(
          context,
          'An unexpected error occurred: ${e.toString()}',
          ThemeUtils.$error,
        );
      }
    }

    isLoading.value = false;
  }
}

// Section Header Widget
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isRequired;

  const _SectionHeader({
    required this.icon,
    required this.title,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ThemeUtils.$primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: ThemeUtils.$primaryColor, size: 18),
        ),
        const Gap(10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ThemeUtils.$primaryColor,
            ),
          ),
        ),
        if (isRequired)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ThemeUtils.$error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Required',
              style: TextStyle(
                color: ThemeUtils.$error,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

// Body Goal Selector Widget
class _BodyGoalSelector extends StatelessWidget {
  final BodyGoal? selectedGoal;
  final Function(BodyGoal?) onChanged;

  const _BodyGoalSelector({
    required this.selectedGoal,
    required this.onChanged,
  });

  IconData _getGoalIcon(BodyGoal goal) {
    switch (goal) {
      case BodyGoal.weightLoss:
        return FluentIcons.arrow_trending_down_24_filled;
      case BodyGoal.maintenance:
        return FluentIcons.checkmark_circle_24_filled;
      case BodyGoal.muscleGain:
        return FluentIcons.arrow_trending_24_regular;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: BodyGoal.values.map((goal) {
        final isSelected = selectedGoal == goal;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () => onChanged(isSelected ? null : goal),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? ThemeUtils.$primaryColor.withOpacity(0.1)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? ThemeUtils.$primaryColor
                      : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ThemeUtils.$primaryColor
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getGoalIcon(goal),
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                      size: 24,
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Text(
                      goal.display,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? ThemeUtils.$primaryColor
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      FluentIcons.checkmark_circle_24_filled,
                      color: ThemeUtils.$primaryColor,
                      size: 24,
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// Enhanced Calorie Target Selector with TDEE Integration
class _CalorieTargetSelector extends StatelessWidget {
  final bool hasTdee;
  final int userTdee;
  final bool useCustomCalories;
  final int calorieTarget;
  final Function(bool) onToggleCustom;
  final Function(int) onChanged;

  const _CalorieTargetSelector({
    required this.hasTdee,
    required this.userTdee,
    required this.useCustomCalories,
    required this.calorieTarget,
    required this.onToggleCustom,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.shade50,
            Colors.deepPurple.shade100.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepPurple.shade200, width: 1.5),
      ),
      child: Column(
        children: [
          // TDEE Info (if available)
          if (hasTdee) ...[
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    FluentIcons.heart_pulse_24_filled,
                    color: Colors.deepPurple.shade700,
                    size: 20,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your TDEE',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.deepPurple.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$userTdee calories/day',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.deepPurple.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: !useCustomCalories,
                  onChanged: (value) => onToggleCustom(!value),
                  activeColor: Colors.deepPurple.shade700,
                ),
              ],
            ),
            const Gap(16),
          ],

          // Custom Calorie Slider (shown when no TDEE or custom is selected)
          if (!hasTdee || useCustomCalories) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Target Calories',
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeUtils.$primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeUtils.$primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${calorieTarget.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} kcal',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ThemeUtils.$secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(12),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              ),
              child: Slider(
                value: calorieTarget.toDouble(),
                min: 1200,
                max: 5000,
                divisions: 38,
                activeColor: ThemeUtils.$primaryColor,
                inactiveColor: ThemeUtils.$primaryColor.withOpacity(0.2),
                onChanged: (value) => onChanged(value.round()),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '1,200',
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeUtils.$primaryColor.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '5,000',
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeUtils.$primaryColor.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ] else ...[
            // Show TDEE is being used
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200, width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    FluentIcons.checkmark_circle_24_filled,
                    color: Colors.green.shade700,
                    size: 20,
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text(
                      'Using your personalized TDEE',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Multi-Select Chips Widget (Enhanced)
class _MultiSelectChips<T> extends StatelessWidget {
  final List<T> options;
  final Set<T> selectedOptions;
  final Function(Set<T>) onChanged;
  final String Function(T) getDisplay;

  const _MultiSelectChips({
    required this.options,
    required this.selectedOptions,
    required this.onChanged,
    required this.getDisplay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      child: options.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'No options available',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ),
            )
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options.map((option) {
                final isSelected = selectedOptions.contains(option);
                return FilterChip(
                  label: Text(getDisplay(option)),
                  selected: isSelected,
                  onSelected: (selected) {
                    final newSelection = Set<T>.from(selectedOptions);
                    if (selected) {
                      newSelection.add(option);
                    } else {
                      newSelection.remove(option);
                    }
                    onChanged(newSelection);
                  },
                  backgroundColor: ThemeUtils.$secondaryColor,
                  selectedColor: ThemeUtils.$primaryColor,
                  checkmarkColor: ThemeUtils.$secondaryColor,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? ThemeUtils.$secondaryColor
                        : ThemeUtils.$primaryColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected
                          ? ThemeUtils.$primaryColor
                          : Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                );
              }).toList(),
            ),
    );
  }
}
