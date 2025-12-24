import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:utakula_v2/common/global_widgets/utakula_side_navigation.dart';
import 'package:utakula_v2/common/helpers/helper_utils.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/reminders/domain/entities/meal_notification_entity.dart';
import 'package:utakula_v2/features/reminders/domain/entities/reminder_entity.dart';
import 'package:utakula_v2/features/reminders/presentation/providers/reminder_provider.dart';

class Reminders extends HookConsumerWidget {
  const Reminders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = Logger();
    HelperUtils helperUtils = HelperUtils();
    final reminderState = ref.watch(reminderStateProvider);

    // State management
    final notificationsEnabled = useState(true);
    final timeBeforeMeals = useState(2);
    final frequencyBeforeMeals = useState(2);

    // Meal times state
    final breakfastEnabled = useState(true);
    final breakfastTime = useState(const TimeOfDay(hour: 8, minute: 0));

    final lunchEnabled = useState(true);
    final lunchTime = useState(const TimeOfDay(hour: 13, minute: 0));

    final supperEnabled = useState(true);
    final supperTime = useState(const TimeOfDay(hour: 19, minute: 0));

    // Save settings
    Future<void> handleSaveSettings() async {
      final List<MealNotificationEntity> notificationFor = [];

      if (breakfastEnabled.value) {
        notificationFor.add(
          MealNotificationEntity(
            meal: 'breakfast',
            mealTime: breakfastTime.value,
          ),
        );
      }
      if (lunchEnabled.value) {
        notificationFor.add(
          MealNotificationEntity(
            meal: 'lunch',
            mealTime: lunchTime.value,
          ),
        );
      }
      if (supperEnabled.value) {
        notificationFor.add(
          MealNotificationEntity(
            meal: 'supper',
            mealTime: supperTime.value,
          ),
        );
      }

      final reminderEntity = ReminderEntity(
        notificationsEnabled: notificationsEnabled.value,
        timeBeforeMeals: timeBeforeMeals.value,
        frequencyBeforeMeals: frequencyBeforeMeals.value,
        notificationFor: notificationFor,
      );

      await ref
          .read(reminderStateProvider.notifier)
          .saveUserNotificationSettings(reminderEntity);

      if (context.mounted) {
        final state = ref.read(reminderStateProvider);
        if (state.errorMessage == null) {
          helperUtils.showSnackBar(
            context,
            'Settings saved successfully!',
            ThemeUtils.$success,
          );
        } else {
          helperUtils.showSnackBar(
            context,
            'An unexpected error occurred: ${state.errorMessage}',
            ThemeUtils.$error,
          );
        }
      }
    }

    // Time picker helper
    Future<void> selectTime(
      BuildContext context,
      TimeOfDay currentTime,
      ValueNotifier<TimeOfDay> timeNotifier,
    ) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: currentTime,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: ThemeUtils.$primaryColor,
                onPrimary: ThemeUtils.$secondaryColor,
                surface: ThemeUtils.$backgroundColor,
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        timeNotifier.value = picked;
      }
    }

    useEffect(() {
      Future.microtask(
        () => ref
            .read(reminderStateProvider.notifier)
            .getUserNotificationSettings(),
      );
      return null;
    }, []);

    useEffect(() {
      if (reminderState.reminder != null) {
        final settings = reminderState.reminder!;

        notificationsEnabled.value = settings.notificationsEnabled;
        timeBeforeMeals.value = settings.timeBeforeMeals;
        frequencyBeforeMeals.value = settings.frequencyBeforeMeals;

        // Reset all meal states before updating
        breakfastEnabled.value = false;
        lunchEnabled.value = false;
        supperEnabled.value = false;

        // Initialize meal times from loaded data
        for (var mealNotif in settings.notificationFor) {
          if (mealNotif.meal.toLowerCase() == 'breakfast') {
            breakfastEnabled.value = true;
            breakfastTime.value = mealNotif.mealTime;
          } else if (mealNotif.meal.toLowerCase() == 'lunch') {
            lunchEnabled.value = true;
            lunchTime.value = mealNotif.mealTime;
          } else if (mealNotif.meal.toLowerCase() == 'supper') {
            supperEnabled.value = true;
            supperTime.value = mealNotif.mealTime;
          }
        }
      }
      return null;
    }, [reminderState.reminder]);

    return Scaffold(
      backgroundColor: ThemeUtils.$backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: const Icon(Icons.reorder),
          ),
        ),
        title: const Text(
          'Meal Reminders',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ThemeUtils.$primaryColor,
          ),
        ),
      ),
      drawer: UtakulaSideNavigation(),
      body: reminderState.isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Lottie.asset(
                      'assets/animations/Loading.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Gap(16),
                  Text(
                    "Loading delicious foods...",
                    style: TextStyle(
                      color: ThemeUtils.$primaryColor.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Master toggle card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ThemeUtils.$primaryColor,
                          ThemeUtils.$primaryColor.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: ThemeUtils.$primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: ThemeUtils.$secondaryColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            FluentIcons.alert_24_filled,
                            color: ThemeUtils.$secondaryColor,
                            size: 28,
                          ),
                        ),
                        const Gap(16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notifications',
                                style: TextStyle(
                                  color: ThemeUtils.$secondaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Gap(4),
                              Text(
                                'Get reminded before meals',
                                style: TextStyle(
                                  color: ThemeUtils.$secondaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: notificationsEnabled.value,
                          onChanged: (value) =>
                              notificationsEnabled.value = value,
                          activeColor: ThemeUtils.$secondaryColor,
                          activeTrackColor: ThemeUtils.$secondaryColor
                              .withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),

                  const Gap(24),

                  // Timing settings
                  AnimatedOpacity(
                    opacity: notificationsEnabled.value ? 1.0 : 0.5,
                    duration: const Duration(milliseconds: 300),
                    child: IgnorePointer(
                      ignoring: !notificationsEnabled.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Reminder Settings',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ThemeUtils.$primaryColor,
                            ),
                          ),
                          const Gap(12),

                          // Time before meals slider
                          _buildSettingCard(
                            icon: FluentIcons.clock_24_regular,
                            title: 'Remind me before meal',
                            subtitle:
                                '${timeBeforeMeals.value} hour${timeBeforeMeals.value > 1 ? "s" : ""}',
                            child: Column(
                              children: [
                                const Gap(8),
                                Row(
                                  children: [
                                    const Icon(
                                      FluentIcons.subtract_circle_24_regular,
                                      color: ThemeUtils.$primaryColor,
                                      size: 20,
                                    ),
                                    Expanded(
                                      child: Slider(
                                        value: timeBeforeMeals.value.toDouble(),
                                        min: 1,
                                        max: 5,
                                        divisions: 4,
                                        activeColor: ThemeUtils.$primaryColor,
                                        inactiveColor: ThemeUtils.$primaryColor
                                            .withOpacity(0.2),
                                        onChanged: (value) {
                                          timeBeforeMeals.value = value.toInt();
                                        },
                                      ),
                                    ),
                                    const Icon(
                                      FluentIcons.add_circle_24_regular,
                                      color: ThemeUtils.$primaryColor,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const Gap(12),

                          // Frequency slider
                          _buildSettingCard(
                            icon: FluentIcons.arrow_repeat_all_24_regular,
                            title: 'Reminder frequency',
                            subtitle:
                                '${frequencyBeforeMeals.value} time${frequencyBeforeMeals.value > 1 ? "s" : ""}',
                            child: Column(
                              children: [
                                const Gap(8),
                                Row(
                                  children: [
                                    const Icon(
                                      FluentIcons.subtract_circle_24_regular,
                                      color: ThemeUtils.$primaryColor,
                                      size: 20,
                                    ),
                                    Expanded(
                                      child: Slider(
                                        value: frequencyBeforeMeals.value
                                            .toDouble(),
                                        min: 1,
                                        max: 5,
                                        divisions: 4,
                                        activeColor: ThemeUtils.$primaryColor,
                                        inactiveColor: ThemeUtils.$primaryColor
                                            .withOpacity(0.2),
                                        onChanged: (value) {
                                          frequencyBeforeMeals.value = value
                                              .toInt();
                                        },
                                      ),
                                    ),
                                    const Icon(
                                      FluentIcons.add_circle_24_regular,
                                      color: ThemeUtils.$primaryColor,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const Gap(24),

                          // Meal times section
                          const Text(
                            'Meal Times',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ThemeUtils.$primaryColor,
                            ),
                          ),
                          const Gap(12),

                          // Breakfast
                          _buildMealTimeCard(
                            context: context,
                            icon: FluentIcons.food_24_regular,
                            mealName: 'Breakfast',
                            time: breakfastTime.value,
                            enabled: breakfastEnabled.value,
                            onToggle: (value) => breakfastEnabled.value = value,
                            onTimeSelect: () => selectTime(
                              context,
                              breakfastTime.value,
                              breakfastTime,
                            ),
                          ),

                          const Gap(12),

                          // Lunch
                          _buildMealTimeCard(
                            context: context,
                            icon: FluentIcons.bowl_salad_24_regular,
                            mealName: 'Lunch',
                            time: lunchTime.value,
                            enabled: lunchEnabled.value,
                            onToggle: (value) => lunchEnabled.value = value,
                            onTimeSelect: () =>
                                selectTime(context, lunchTime.value, lunchTime),
                          ),

                          const Gap(12),

                          // Supper
                          _buildMealTimeCard(
                            context: context,
                            icon: FluentIcons.food_24_filled,
                            mealName: 'Supper',
                            time: supperTime.value,
                            enabled: supperEnabled.value,
                            onToggle: (value) => supperEnabled.value = value,
                            onTimeSelect: () => selectTime(
                              context,
                              supperTime.value,
                              supperTime,
                            ),
                          ),

                          const Gap(32),

                          // Save button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: reminderState.isSubmitting
                                  ? null
                                  : handleSaveSettings,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeUtils.$primaryColor,
                                foregroundColor: ThemeUtils.$secondaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 4,
                                shadowColor: ThemeUtils.$primaryColor
                                    .withOpacity(0.3),
                              ),
                              child: reminderState.isSubmitting
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              ThemeUtils.$secondaryColor,
                                            ),
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FluentIcons.save_24_regular,
                                          size: 20,
                                        ),
                                        Gap(8),
                                        Text(
                                          'Save Settings',
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
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeUtils.$secondaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeUtils.$primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: ThemeUtils.$primaryColor, size: 20),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ThemeUtils.$primaryColor,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: ThemeUtils.$primaryColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildMealTimeCard({
    required BuildContext context,
    required IconData icon,
    required String mealName,
    required TimeOfDay time,
    required bool enabled,
    required Function(bool) onToggle,
    required VoidCallback onTimeSelect,
  }) {
    return AnimatedOpacity(
      opacity: enabled ? 1.0 : 0.6,
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeUtils.$secondaryColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: enabled
                ? ThemeUtils.$primaryColor.withOpacity(0.2)
                : ThemeUtils.$primaryColor.withOpacity(0.1),
            width: enabled ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: enabled
                    ? ThemeUtils.$primaryColor.withOpacity(0.1)
                    : ThemeUtils.$primaryColor.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: ThemeUtils.$primaryColor, size: 24),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mealName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ThemeUtils.$primaryColor,
                    ),
                  ),
                  const Gap(4),
                  GestureDetector(
                    onTap: enabled ? onTimeSelect : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: enabled
                            ? ThemeUtils.$primaryColor.withOpacity(0.1)
                            : ThemeUtils.$primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            FluentIcons.clock_24_regular,
                            size: 14,
                            color: ThemeUtils.$primaryColor.withOpacity(
                              enabled ? 0.7 : 0.4,
                            ),
                          ),
                          const Gap(6),
                          Text(
                            time.format(context),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: ThemeUtils.$primaryColor.withOpacity(
                                enabled ? 0.8 : 0.4,
                              ),
                            ),
                          ),
                          if (enabled) ...[
                            const Gap(4),
                            Icon(
                              FluentIcons.edit_24_regular,
                              size: 12,
                              color: ThemeUtils.$primaryColor.withOpacity(0.6),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: enabled,
              onChanged: onToggle,
              activeColor: ThemeUtils.$primaryColor,
              activeTrackColor: ThemeUtils.$primaryColor.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}
