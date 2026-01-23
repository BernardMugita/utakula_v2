import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/common/global_widgets/utakula_side_navigation.dart';
import 'package:utakula_v2/common/helpers/helper_utils.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/presentation/providers/meal_plan_provider.dart';
import 'package:utakula_v2/features/meal_plan/presentation/widgets/action_buttons.dart';
import 'package:utakula_v2/features/meal_plan/presentation/widgets/day_card.dart';
import 'package:utakula_v2/features/meal_plan/presentation/widgets/info_banner.dart';
import 'package:utakula_v2/features/meal_plan/presentation/widgets/meal_plan_suggestion_dialog.dart';

class MealPlanController extends HookConsumerWidget {
  final MealPlanEntity? userMealPlan;

  const MealPlanController({super.key, this.userMealPlan});

  // Add this helper function to the MealPlanController class
  Future<void> _showSuggestMealPlanDialog(
    BuildContext context,
    ValueNotifier<List<Map<String, dynamic>>> mealPlan,
    ValueNotifier<String?> mealPlanId,
    HelperUtils helperUtils,
    Logger logger,
  ) async {
    final MealPlanEntity? suggestedMealPlan = await showDialog<MealPlanEntity>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const MealPlanSuggestionDialog(),
    );

    if (suggestedMealPlan != null && context.mounted) {
      logger.i(
        'Initializing with suggested meal plan: ${suggestedMealPlan.id}',
      );
      final convertedPlan = helperUtils.convertEntityToMap(suggestedMealPlan);
      mealPlan.value = convertedPlan;
      // DO NOT update originalMealPlan, so it's treated as a change
      mealPlanId.value = suggestedMealPlan.id;
      logger.d('Converted suggested meal plan: ${mealPlan.value}');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = Logger();
    final helperUtils = HelperUtils();

    // State management using hooks
    final mealPlan = useState<List<Map<String, dynamic>>>(
      helperUtils.getInitialMealPlan(),
    );
    final originalMealPlan = useState<List<Map<String, dynamic>>>(
      helperUtils.getInitialMealPlan(),
    );
    final isLoading = useState(false);
    final validationMessage = useState('');
    final mealPlanId = useState<String?>(null);
    final dialogShown = useState(false);

    // Initialize meal plan from user data OR show suggestion dialog
    useEffect(() {
      if (userMealPlan != null) {
        logger.i('Initializing with user meal plan: ${userMealPlan!.id}');
        final convertedPlan = helperUtils.convertEntityToMap(userMealPlan!);
        mealPlan.value = convertedPlan;
        originalMealPlan.value = helperUtils.deepCopyMapList(convertedPlan);
        mealPlanId.value = userMealPlan!.id;
      }
      return null;
    }, []);

    useEffect(() {
      if (userMealPlan == null && !dialogShown.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Future.delayed(const Duration(seconds: 1));

          if (context.mounted && !dialogShown.value) {
            dialogShown.value = true;
            await _showSuggestMealPlanDialog(
              context,
              mealPlan,
              mealPlanId,
              helperUtils,
              logger,
            );
          }
        });
      }
      return null;
    }, []);

    // Check if meal plan has unsaved changes
    bool hasUnsavedChanges() {
      return helperUtils.hasMealPlanChanged(
        originalMealPlan.value,
        mealPlan.value,
      );
    }

    // Update meal plan for a specific day
    void updateMealPlan(
      String day,
      Map<dynamic, dynamic> meals,
      int totalCals,
    ) {
      final updatedPlan = mealPlan.value.map((plan) {
        if (plan['day'] == day) {
          return {
            'day': plan['day'],
            'meals': Map<String, dynamic>.from(meals),
            'total_calories': totalCals,
          };
        }
        return plan;
      }).toList();

      mealPlan.value = List.from(updatedPlan);
    }

    // Handle save draft
    Future<void> handleSaveDraft() async {
      isLoading.value = true;
      // TODO: Implement save draft logic with your API
      await Future.delayed(const Duration(milliseconds: 500));
      isLoading.value = false;
      if (context.mounted) {
        helperUtils.showSnackBar(
          context,
          "Draft saved successfully!",
          ThemeUtils.$success,
        );
      }
    }

    // Handle save meal plan
    Future<void> handleSaveMealPlan() async {
      // Validate meal plan
      if (mealPlan.value.isEmpty) {
        validationMessage.value = 'Meal plan is empty';
        helperUtils.showSnackBar(
          context,
          "Meal plan is empty",
          ThemeUtils.$success,
        );
        return;
      }

      for (var meal in mealPlan.value) {
        if (meal['meals'].isEmpty) {
          validationMessage.value =
              "Please finish preparing your meal plan. Missing meals for ${meal['day']}";
          helperUtils.showSnackBar(
            context,
            "Please finish preparing your meal plan. Missing meals for ${meal['day']}",
            ThemeUtils.$success,
          );
          return;
        }
      }

      try {
        final mealPlanEntity = helperUtils.convertMapToEntity(
          mealPlan.value,
          mealPlanId.value ?? '',
          userMealPlan?.members ?? [],
        );

        final notifier = ref.read(mealPlanStateProvider.notifier);

        // Decide whether to create or update
        final bool success;
        if (userMealPlan != null && mealPlanId.value != null) {
          success = await notifier.updateMealPlan(mealPlanEntity);
        } else {
          // For suggested meal plans, we're creating a new one (not updating the suggestion)
          success = await notifier.createMealPlan(mealPlanEntity);
        }

        if (success) {
          if (context.mounted) {
            helperUtils.showSnackBar(
              context,
              userMealPlan != null
                  ? 'Meal plan updated successfully!'
                  : 'Meal plan created successfully!',
              ThemeUtils.$success,
            );
            context.pop();
          }
        } else {
          if (context.mounted) {
            final errorMessage =
                ref.read(mealPlanStateProvider).errorMessage ??
                'Failed to save meal plan.';
            helperUtils.showSnackBar(context, errorMessage, ThemeUtils.$error);
          }
        }
      } catch (e) {
        logger.e('Error saving meal plan: $e');
        if (context.mounted) {
          helperUtils.showSnackBar(
            context,
            'An unexpected error occurred: ${e.toString()}',
            ThemeUtils.$success,
          );
        }
      }
    }

    // Handle back button press
    void handleBackPress() {
      if (hasUnsavedChanges()) {
        _showDiscardDialog(context, ref);
      } else {
        context.pop();
      }
    }

    return PopScope(
      canPop: !hasUnsavedChanges(),
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && hasUnsavedChanges()) {
          _showDiscardDialog(context, ref);
        }
      },
      child: Scaffold(
        backgroundColor: ThemeUtils.$backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            userMealPlan == null ? "Create new meal plan" : "Edit Meal Plan",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: ThemeUtils.$primaryColor,
            ),
          ),
          leading: IconButton(
            icon: const Icon(FluentIcons.arrow_left_24_filled),
            onPressed: handleBackPress,
          ),
        ),
        drawer: UtakulaSideNavigation(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              InfoBanner(
                message: userMealPlan == null
                    ? "Click on the '+' on a single item to prepare a day's meal plan."
                    : "Select the 'edit' on each day's plan to edit the foods.",
              ),
              const Gap(10), // Add a small gap
              Text(
                'Tap the magic wand button to get meal plan suggestions!',
                style: TextStyle(
                  fontSize: 14,
                  color: ThemeUtils.$primaryColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(20),
              _buildMealPlanGrid(
                context,
                mealPlan.value,
                updateMealPlan,
                validationMessage.value,
              ),
              const Gap(10),
              ActionButtons(
                isLoading: isLoading.value,
                onSaveDraft: handleSaveDraft,
                onSaveMealPlan: handleSaveMealPlan,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showSuggestMealPlanDialog(
            context,
            mealPlan,
            mealPlanId,
            helperUtils,
            logger,
          ),
          backgroundColor: ThemeUtils.$primaryColor,
          child: const Icon(
            FluentIcons.sparkle_24_filled,
            color: ThemeUtils.$secondaryColor,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      ),
    );
  }

  // Build the grid of day cards
  Widget _buildMealPlanGrid(
    BuildContext context,
    List<Map<String, dynamic>> mealPlan,
    Function(String, Map, int) updateMealPlan,
    String validationMessage,
  ) {

    Logger logger = Logger();
    logger.d(mealPlan);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ThemeUtils.$secondaryColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        alignment: WrapAlignment.center,
        children: mealPlan.map((plan) {
          return DayCard(
            day: plan['day'],
            meals: plan['meals'] as Map,
            totalCalories: plan['total_calories'] != null
                ? double.parse(plan['total_calories'].toString())
                : double.parse(plan['calories'].toString()),
            hasError:
                validationMessage.startsWith("Please") && plan['meals'].isEmpty,
            onUpdate: (meals, calories) {
              updateMealPlan(plan['day'], meals, calories);
            },
          );
        }).toList(),
      ),
    );
  }

  // Show discard changes dialog
  void _showDiscardDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Close without saving?',
            style: TextStyle(color: ThemeUtils.$primaryColor),
          ),
          content: const Text(
            'You have made changes to your meal plan that will be lost if you close without saving.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continue'),
            ),
            TextButton(
              onPressed: () {
                // Clear the current meal plan from the state provider
                ref.read(mealPlanStateProvider.notifier).clearCurrentMealPlan();
                context.pop(); // Close dialog
                context.pop(); // Close meal plan controller
              },
              child: const Text(
                'Discard Changes',
                style: TextStyle(color: ThemeUtils.$error),
              ),
            ),
          ],
        );
      },
    );
  }
}
