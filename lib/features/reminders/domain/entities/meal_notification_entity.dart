import 'package:flutter/material.dart';

class MealNotificationEntity {
  final String meal;
  final TimeOfDay mealTime;

  const MealNotificationEntity({required this.meal, required this.mealTime});
}
