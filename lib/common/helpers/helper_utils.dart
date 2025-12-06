import 'package:flutter/material.dart';

class HelperUtils {
  /// Convert day name to weekday number (1-7, where 1 is Monday)
  int convertDayToNumber(String day) {
    const daysOfWeek = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };

    return daysOfWeek[day] ?? 0;
  }

  /// Get full meal name from list of food names
  String getFullMealName(List<dynamic> mealNames) {
    if (mealNames.isEmpty) return 'No items';
    if (mealNames.length == 1) return mealNames[0].toString();
    if (mealNames.length == 2) {
      return '${mealNames[0]} & ${mealNames[1]}';
    }

    // For 3 or more items
    final firstTwo = mealNames.take(2).join(', ');
    return '$firstTwo & ${mealNames.length - 2} more';
  }

  /// Check if a day is today
  bool isDayToday(String day) {
    final daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final currentDayIndex = DateTime.now().weekday - 1;
    return day == daysOfWeek[currentDayIndex];
  }

  /// Get current meal time (breakfast, lunch, or supper)
  String getCurrentMealTime() {
    final now = TimeOfDay.now();
    if (now.hour < 11) {
      return 'breakfast';
    } else if (now.hour < 14) {
      return 'lunch';
    } else {
      return 'supper';
    }
  }

  /// Get initial carousel page based on time
  int getInitialPageBasedOnTime() {
    final now = TimeOfDay.now();
    if (now.hour < 11) {
      return 0; // Breakfast
    } else if (now.hour < 14) {
      return 1; // Lunch
    } else {
      return 2; // Supper
    }
  }
}
