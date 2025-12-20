import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/common/helpers/helper_utils.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/meal_plan/data/enums/meal_plan_enums.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/presentation/providers/meal_plan_provider.dart';

class MealPlanSuggestionDialog extends HookConsumerWidget {
  const MealPlanSuggestionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bodyGoal = useState<BodyGoal?>(null);
    final calorieTarget = useState<int>(2000);
    final selectedRestrictions = useState<Set<DietaryRestriction>>({});
    final selectedAllergies = useState<Set<FoodAllergy>>({});
    final selectedConditions = useState<Set<MedicalDietaryCondition>>({});
    final isLoading = useState(false);
    HelperUtils helperUtils = HelperUtils();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: ThemeUtils.$secondaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Meal Plan Suggestion',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ThemeUtils.$primaryColor,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        FluentIcons.dismiss_24_regular,
                        color: ThemeUtils.$primaryColor,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Gap(8),
                Text(
                  'Tell us about your goals and preferences',
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeUtils.$primaryColor.withOpacity(0.7),
                  ),
                ),
                const Gap(24),

                // Body Goal Section
                _SectionHeader(
                  icon: FluentIcons.target_24_regular,
                  title: 'Body Goal',
                  isRequired: true,
                ),
                const Gap(12),
                _BodyGoalSelector(
                  selectedGoal: bodyGoal.value,
                  onChanged: (goal) => bodyGoal.value = goal,
                ),
                const Gap(24),

                // Calorie Target Section
                _SectionHeader(
                  icon: FluentIcons.food_24_regular,
                  title: 'Daily Calorie Target',
                  isRequired: true,
                ),
                const Gap(12),
                _CalorieTargetSelector(
                  calorieTarget: calorieTarget.value,
                  onChanged: (value) => calorieTarget.value = value,
                ),
                const Gap(24),

                // Dietary Restrictions Section
                _SectionHeader(
                  icon: FluentIcons.shield_checkmark_24_regular,
                  title: 'Dietary Restrictions',
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
                  icon: FluentIcons.warning_24_regular,
                  title: 'Food Allergies',
                ),
                const Gap(12),
                _MultiSelectChips<FoodAllergy>(
                  options: FoodAllergy.values,
                  selectedOptions: selectedAllergies.value,
                  onChanged: (allergies) => selectedAllergies.value = allergies,
                  getDisplay: (item) => item.display,
                ),
                const Gap(24),

                // Medical Conditions Section
                _SectionHeader(
                  icon: FluentIcons.heart_pulse_24_regular,
                  title: 'Medical Conditions',
                ),
                const Gap(12),
                _MultiSelectChips<MedicalDietaryCondition>(
                  options: MedicalDietaryCondition.values,
                  selectedOptions: selectedConditions.value,
                  onChanged: (conditions) =>
                      selectedConditions.value = conditions,
                  getDisplay: (item) => item.display,
                ),
                const Gap(32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isLoading.value
                            ? null
                            : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ThemeUtils.$primaryColor,
                          side: const BorderSide(
                            color: ThemeUtils.$primaryColor,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed:
                            isLoading.value ||
                                bodyGoal.value == null ||
                                calorieTarget.value < 1200
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
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
                                  Icon(FluentIcons.sparkle_24_filled, size: 20),
                                  Gap(8),
                                  Text(
                                    'Suggest Meal Plan',
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
              ],
            ),
          ),
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
    HelperUtils helperUtils = HelperUtils();
    Logger logger = Logger();

    // Prepare the request body
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

      // This method will be changed in the provider to return the entity directly
      // without updating the state.
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

          // Close the dialog and pass the suggested meal plan back
          Navigator.of(context).pop(suggestedMealPlan);
        }
      } else {
        if (context.mounted) {
          final errorMessage =
              ref.read(mealPlanStateProvider).errorMessage ??
              'Failed to suggest meal plan.';
          helperUtils.showSnackBar(context, errorMessage, ThemeUtils.$success);
        }
      }
    } catch (e) {
      logger.e('Error suggesting meal plan: $e');
      if (context.mounted) {
        helperUtils.showSnackBar(
          context,
          'An unexpected error occurred: ${e.toString()}',
          ThemeUtils.$success,
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
        Icon(icon, color: ThemeUtils.$primaryColor, size: 20),
        const Gap(8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ThemeUtils.$primaryColor,
          ),
        ),
        if (isRequired) ...[
          const Gap(4),
          const Text(
            '*',
            style: TextStyle(
              color: ThemeUtils.$error,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: BodyGoal.values.map((goal) {
        final isSelected = selectedGoal == goal;
        return ChoiceChip(
          label: Text(goal.display),
          selected: isSelected,
          onSelected: (selected) => onChanged(selected ? goal : null),
          backgroundColor: ThemeUtils.$backgroundColor,
          selectedColor: ThemeUtils.$primaryColor,
          labelStyle: TextStyle(
            color: isSelected
                ? ThemeUtils.$secondaryColor
                : ThemeUtils.$primaryColor,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected
                  ? ThemeUtils.$primaryColor
                  : ThemeUtils.$primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        );
      }).toList(),
    );
  }
}

// Calorie Target Selector Widget
class _CalorieTargetSelector extends StatelessWidget {
  final int calorieTarget;
  final Function(int) onChanged;

  const _CalorieTargetSelector({
    required this.calorieTarget,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeUtils.$backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Calories per day',
                style: TextStyle(
                  fontSize: 14,
                  color: ThemeUtils.$primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: ThemeUtils.$primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$calorieTarget kcal',
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
          Slider(
            value: calorieTarget.toDouble(),
            min: 1200,
            max: 5000,
            divisions: 38,
            activeColor: ThemeUtils.$primaryColor,
            inactiveColor: ThemeUtils.$primaryColor.withOpacity(0.2),
            onChanged: (value) => onChanged(value.round()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1,200',
                style: TextStyle(
                  fontSize: 12,
                  color: ThemeUtils.$primaryColor.withOpacity(0.6),
                ),
              ),
              Text(
                '5,000',
                style: TextStyle(
                  fontSize: 12,
                  color: ThemeUtils.$primaryColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Multi-Select Chips Widget
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeUtils.$backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: options.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'No options available',
                  style: TextStyle(
                    color: ThemeUtils.$primaryColor,
                    fontSize: 14,
                  ),
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
                  selectedColor: ThemeUtils.$primaryColor.withOpacity(0.2),
                  checkmarkColor: ThemeUtils.$primaryColor,
                  labelStyle: TextStyle(
                    color: ThemeUtils.$primaryColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isSelected
                          ? ThemeUtils.$primaryColor
                          : ThemeUtils.$primaryColor.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                );
              }).toList(),
            ),
    );
  }
}
