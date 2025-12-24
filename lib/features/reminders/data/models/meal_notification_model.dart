import 'package:flutter/material.dart';
import 'package:utakula_v2/features/reminders/domain/entities/meal_notification_entity.dart';

class MealNotificationModel {
  final String meal;
  final TimeOfDay mealTime;

  const MealNotificationModel({required this.meal, required this.mealTime});

  factory MealNotificationModel.fromJson(Map<String, dynamic> json) {
    // Parse the time string "HH:MM" to TimeOfDay
    final timeString = json['meal_time'] as String;
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return MealNotificationModel(
      meal: json['meal'],
      mealTime: TimeOfDay(hour: hour, minute: minute),
    );
  }

  Map<String, dynamic> toJson() {
    // Convert TimeOfDay to "HH:MM" format
    final hour = mealTime.hour.toString().padLeft(2, '0');
    final minute = mealTime.minute.toString().padLeft(2, '0');

    return {'meal': meal, 'meal_time': '$hour:$minute'};
  }

  factory MealNotificationModel.fromEntity(
    MealNotificationEntity notificationEntity,
  ) {
    return MealNotificationModel(
      meal: notificationEntity.meal,
      mealTime: notificationEntity.mealTime,
    );
  }

  MealNotificationEntity toEntity() {
    return MealNotificationEntity(meal: meal, mealTime: mealTime);
  }
}
