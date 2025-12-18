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

class MealPlanController extends HookConsumerWidget {
  final MealPlanEntity? userMealPlan;

  const MealPlanController({super.key, this.userMealPlan});

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

    // Initialize meal plan from user data
    useEffect(() {
      if (userMealPlan != null) {
        logger.i('Initializing with user meal plan: ${userMealPlan!.id}');
        final convertedPlan = helperUtils.convertEntityToMap(userMealPlan!);
        mealPlan.value = convertedPlan;
        originalMealPlan.value = helperUtils.deepCopyMapList(convertedPlan);
        mealPlanId.value = userMealPlan!.id;
        logger.d('Converted meal plan: ${mealPlan.value}');
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
        _showSuccessSnackBar(context, 'Draft saved successfully!');
      }
    }

    // Handle save meal plan
    Future<void> handleSaveMealPlan() async {
      // Validate meal plan
      if (mealPlan.value.isEmpty) {
        validationMessage.value = 'Meal plan is empty';
        _showErrorSnackBar(context, 'Meal plan is empty');
        return;
      }

      for (var meal in mealPlan.value) {
        if (meal['meals'].isEmpty) {
          validationMessage.value =
              "Please finish preparing your meal plan. Missing meals for ${meal['day']}";
          _showErrorSnackBar(context, validationMessage.value);
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
          logger.w('Update not implemented, creating new meal plan instead');
        } else {
          success = await notifier.createMealPlan(mealPlanEntity);
        }

        if (success) {
          if (context.mounted) {
            _showSuccessSnackBar(
              context,
              userMealPlan != null
                  ? 'Meal plan updated successfully!'
                  : 'Meal plan created successfully!',
            );
            context.pop();
          }
        } else {
          if (context.mounted) {
            final errorMessage =
                ref.read(mealPlanStateProvider).errorMessage ??
                'Failed to save meal plan.';
            _showErrorSnackBar(context, errorMessage);
          }
        }
      } catch (e) {
        logger.e('Error saving meal plan: $e');
        if (context.mounted) {
          _showErrorSnackBar(
            context,
            'An unexpected error occurred: ${e.toString()}',
          );
        }
      }
    }

    // Handle back button press
    void handleBackPress() {
      if (hasUnsavedChanges()) {
        _showDiscardDialog(context);
      } else {
        context.pop();
      }
    }

    return PopScope(
      canPop: !hasUnsavedChanges(),
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && hasUnsavedChanges()) {
          _showDiscardDialog(context);
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
            totalCalories: plan['total_calories'],
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
  void _showDiscardDialog(BuildContext context) {
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

  // Show error snackbar
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ThemeUtils.$error,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: ThemeUtils.$blacks,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Show success snackbar
  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ThemeUtils.$primaryColor,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: ThemeUtils.$secondaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
