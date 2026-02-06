import 'package:utakula_v2/features/reminders/data/models/meal_notification_model.dart';
import 'package:utakula_v2/features/reminders/domain/entities/reminder_entity.dart';

class ReminderModel {
  final bool notificationsEnabled;
  final int timeBeforeMeals;
  final int frequencyBeforeMeals;
  final List<MealNotificationModel> notificationFor;

  const ReminderModel({
    required this.notificationsEnabled,
    required this.timeBeforeMeals,
    required this.frequencyBeforeMeals,
    required this.notificationFor,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      notificationsEnabled: json['notifications_enabled'] as bool,
      timeBeforeMeals: json['time_before_meals'] as int,
      frequencyBeforeMeals: json['frequency_before_meals'] as int,
      notificationFor:
          (json['notification_for'] as List<dynamic>?)
              ?.map(
                (item) => MealNotificationModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications_enabled': notificationsEnabled,
      'time_before_meals': timeBeforeMeals,
      'frequency_before_meals': frequencyBeforeMeals,
      'notification_for': notificationFor.map((item) => item.toJson()).toList(),
    };
  }

  factory ReminderModel.fromEntity(ReminderEntity entity) {
    return ReminderModel(
      notificationsEnabled: entity.notificationsEnabled,
      timeBeforeMeals: entity.timeBeforeMeals,
      frequencyBeforeMeals: entity.frequencyBeforeMeals,
      notificationFor: entity.notificationFor
          .map((e) => MealNotificationModel.fromEntity(e))
          .toList(),
    );
  }

  ReminderEntity toEntity() {
    return ReminderEntity(
      notificationsEnabled: notificationsEnabled,
      timeBeforeMeals: timeBeforeMeals,
      frequencyBeforeMeals: frequencyBeforeMeals,
      notificationFor: notificationFor.map((item) => item.toEntity()).toList(),
    );
  }
}
