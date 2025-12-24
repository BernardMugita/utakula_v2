// reminder_entity.dart
import 'package:utakula_v2/features/reminders/domain/entities/meal_notification_entity.dart';

class ReminderEntity {
  final bool notificationsEnabled;
  final int timeBeforeMeals;
  final int frequencyBeforeMeals;
  final List<MealNotificationEntity> notificationFor; // Changed to List

  const ReminderEntity({
    required this.notificationsEnabled,
    required this.timeBeforeMeals,
    required this.frequencyBeforeMeals,
    required this.notificationFor,
  });
}
