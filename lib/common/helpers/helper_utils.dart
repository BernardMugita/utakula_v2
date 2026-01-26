import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/core/error/exceptions.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/day_meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/single_meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/total_macros.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/user_meal_plan_prefs_entity.dart';

class HelperUtils {
  Logger logger = Logger();

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

  // Get initial empty meal plan
  List<Map<String, dynamic>> getInitialMealPlan() {
    return [
      {"day": "Monday", "meals": {}, "total_calories": 0},
      {"day": "Tuesday", "meals": {}, "total_calories": 0},
      {"day": "Wednesday", "meals": {}, "total_calories": 0},
      {"day": "Thursday", "meals": {}, "total_calories": 0},
      {"day": "Friday", "meals": {}, "total_calories": 0},
      {"day": "Saturday", "meals": {}, "total_calories": 0},
      {"day": "Sunday", "meals": {}, "total_calories": 0},
    ];
  }

  // Convert MealPlanEntity to Map format for editing
  List<Map<String, dynamic>> convertEntityToMap(MealPlanEntity entity) {
    return entity.mealPlan.map((dayPlan) {
      // Convert breakfast foods
      final breakfastList = dayPlan.mealPlan.breakfast.map((food) {
        return {
          'id': food.id,
          'name': food.foodName,
          'image_url': food.imageUrl,
          'grams': food.grams,
          'macros': food.macros,
          'servings': food.servings,
          'calories_per_100g': food.caloriesPer100G,
          'calories': food.calories,
        };
      }).toList();

      // Convert lunch foods
      final lunchList = dayPlan.mealPlan.lunch.map((food) {
        return {
          'id': food.id,
          'name': food.foodName,
          'image_url': food.imageUrl,
          'grams': food.grams,
          'macros': food.macros,
          'servings': food.servings,
          'calories_per_100g': food.caloriesPer100G,
          'calories': food.calories,
        };
      }).toList();

      // Convert supper foods
      final supperList = dayPlan.mealPlan.supper.map((food) {
        return {
          'id': food.id,
          'name': food.foodName,
          'image_url': food.imageUrl,
          'grams': food.grams,
          'macros': food.macros,
          'servings': food.servings,
          'calories_per_100g': food.caloriesPer100G,
          'calories': food.calories,
        };
      }).toList();

      return {
        'day': dayPlan.day,
        'meals': {
          'breakfast': breakfastList,
          'lunch': lunchList,
          'supper': supperList,
        },
        'total_calories': dayPlan.totalCalories,
      };
    }).toList();
  }

  // Convert Map format back to MealPlanEntity
  MealPlanEntity convertMapToEntity(
    List<Map<String, dynamic>> mapList,
    String id,
    List members,
  ) {
    final dayMealPlans = mapList.map((plan) {
      // Helper function to convert meal list
      List<MealTypeFoodEntity> convertMealList(List<dynamic>? mealList) {
        if (mealList == null || mealList.isEmpty) {
          return [];
        }

        return mealList.map((food) {
          final foodId =
              food['id']?.toString() ?? food['food_id']?.toString() ?? '';

          return MealTypeFoodEntity(
            id: foodId,
            foodName: food['name']?.toString() ?? 'Unknown',
            imageUrl:
                food['imageUrl']?.toString() ??
                food['image_url']?.toString() ??
                '',
            grams: (food['grams'] is double)
                ? food['grams'] as double
                : (food['grams'] as num?)?.toDouble() ?? 0.0,
            macros: food['macros'] is TotalMacros
                ? food['macros'] as TotalMacros
                : food['macros'] is Map
                ? TotalMacros.fromJson(food['macros'] as Map<String, dynamic>)
                : TotalMacros(
                    proteinGrams: 0.0,
                    carbohydrateGrams: 0.0,
                    fatGrams: 0.0,
                    fibreGrams: 0.0,
                  ),
            servings: (food['servings'] is double)
                ? food['servings'] as double
                : (food['servings'] as num?)?.toDouble() ?? 0.0,
            caloriesPer100G: (food['calories_per_100g'] is double)
                ? food['calories_per_100g'] as double
                : (food['calories_per_100g'] as num?)?.toDouble() ?? 0.0,
            calories: (food['calories'] is double)
                ? food['calories'] as double
                : (food['calories'] as num?)?.toDouble() ?? 0.0,
          );
        }).toList();
      }

      final meals = plan['meals'] as Map<String, dynamic>;

      final breakfast = convertMealList(meals['breakfast']);
      final lunch = convertMealList(meals['lunch']);
      final supper = convertMealList(meals['supper']);

      final allMeals = [...breakfast, ...lunch, ...supper];
      double totalProtein = 0;
      double totalCarbs = 0;
      double totalFat = 0;
      double totalFibre = 0;

      for (var meal in allMeals) {
        totalProtein += meal.macros.proteinGrams;
        totalCarbs += meal.macros.carbohydrateGrams;
        totalFat += meal.macros.fatGrams;
        totalFibre += meal.macros.fibreGrams;
      }

      final calculatedMacros = TotalMacros(
        proteinGrams: totalProtein,
        carbohydrateGrams: totalCarbs,
        fatGrams: totalFat,
        fibreGrams: totalFibre,
      );

      return DayMealPlanEntity(
        day: plan['day'],
        mealPlan: SingleMealPlanEntity(
          breakfast: breakfast,
          lunch: lunch,
          supper: supper,
        ),
        totalCalories: (plan['total_calories'] as num?)?.toDouble() ?? 0.0,
        totalMacros: calculatedMacros,
      );
    }).toList();

    return MealPlanEntity(id: id, members: members, mealPlan: dayMealPlans);
  }

  convertUserPrefsToEntity(Map<String, dynamic> userPrefs) {
    return UserMealPlanPrefsEntity(
      bodyGoal: userPrefs['body_goal'],
      dailyCalorieTarget: userPrefs['daily_calorie_target'] as int,
      dietaryRestrictions: userPrefs['dietary_restrictions'],
      allergies: userPrefs['allergies'],
      useCalculatedTDEE: userPrefs['use_calculated_tdee'],
      medicalConditions: userPrefs['medical_conditions'],
    );
  }

  // Deep copy a list of maps
  List<Map<String, dynamic>> deepCopyMapList(
    List<Map<String, dynamic>> original,
  ) {
    return original.map((item) {
      final meals = item['meals'] as Map<String, dynamic>;
      final copiedMeals = <String, dynamic>{};

      // Deep copy each meal list
      meals.forEach((key, value) {
        if (value is List) {
          copiedMeals[key] = List<Map<String, dynamic>>.from(
            value.map((food) => Map<String, dynamic>.from(food as Map)),
          );
        }
      });

      return {
        'day': item['day'],
        'meals': copiedMeals,
        'total_calories': item['total_calories'],
      };
    }).toList();
  }

  // Check if meal plan has changed
  bool hasMealPlanChanged(
    List<Map<String, dynamic>> original,
    List<Map<String, dynamic>> current,
  ) {
    if (original.length != current.length) return true;

    for (int i = 0; i < original.length; i++) {
      if (original[i]['day'] != current[i]['day']) return true;
      if (original[i]['total_calories'] != current[i]['total_calories']) {
        return true;
      }

      final originalMeals = original[i]['meals'] as Map;
      final currentMeals = current[i]['meals'] as Map;

      if (originalMeals.length != currentMeals.length) return true;

      for (var key in originalMeals.keys) {
        if (!currentMeals.containsKey(key)) return true;

        final origList = originalMeals[key] as List;
        final currList = currentMeals[key] as List;

        if (origList.length != currList.length) return true;

        // Check if individual items changed
        for (int j = 0; j < origList.length; j++) {
          final origItem = origList[j] as Map;
          final currItem = currList[j] as Map;

          if (origItem['id'] != currItem['id'] ||
              origItem['name'] != currItem['name'] ||
              origItem['calories'] != currItem['calories']) {
            return true;
          }
        }
      }
    }

    return false;
  }

  void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Handle exceptions
  // ---------------------------------------------------------------------------

  Exception handleException(DioException e) {
    if (e.response != null) {
      logger.e("Server error: ${e.response?.data}");
      return ServerException(
        e.response?.data['message'] ?? e.message ?? "Server error",
      );
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      logger.e("Connection timeout: ${e.message}");
      return NetworkException("Connection timeout");
    } else if (e.type == DioExceptionType.connectionError) {
      logger.e("No internet: ${e.message}");
      return NetworkException("No internet connection");
    } else {
      logger.e("Unknown error: ${e.message}");
      return ServerException(e.message ?? "Unknown error occurred");
    }
  }
}
