import 'package:utakula_v2/features/meal_plan/domain/entities/user_meal_plan_prefs_entity.dart';

class UserMealPlanPrefsModel {
  final String bodyGoal;
  final List<String> dietaryRestrictions;
  final List<String> allergies;
  final int dailyCalorieTarget;
  final bool useCalculatedTDEE;
  final List<String> medicalConditions;

  const UserMealPlanPrefsModel({
    required this.bodyGoal,
    required this.dietaryRestrictions,
    required this.allergies,
    required this.dailyCalorieTarget,
    required this.useCalculatedTDEE,
    required this.medicalConditions,
  });

  factory UserMealPlanPrefsModel.fromEntity(UserMealPlanPrefsEntity entity) {
    return UserMealPlanPrefsModel(
      bodyGoal: entity.bodyGoal,
      dietaryRestrictions: entity.dietaryRestrictions,
      allergies: entity.allergies,
      dailyCalorieTarget: entity.dailyCalorieTarget,
      useCalculatedTDEE: entity.useCalculatedTDEE,
      medicalConditions: entity.medicalConditions,
    );
  }

  factory UserMealPlanPrefsModel.fromJson(Map<String, dynamic> json) {
    return UserMealPlanPrefsModel(
      bodyGoal: json['body_goal'] as String,
      dietaryRestrictions: json['dietary_restrictions'] as List<String>,
      allergies: json['allergies'] as List<String>,
      dailyCalorieTarget: json['daily_calorie_target'] as int,
      useCalculatedTDEE: json['use_calculated_tdee'] as bool,
      medicalConditions: json['medical_conditions'] as List<String>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'body_goal': bodyGoal,
      'dietary_restrictions': dietaryRestrictions,
      'allergies': allergies,
      'daily_calorie_target': dailyCalorieTarget,
      'use_calculated_tdee': useCalculatedTDEE,
      'medical_conditions': medicalConditions,
    };
  }

  UserMealPlanPrefsEntity toEntity() {
    return UserMealPlanPrefsEntity(
      bodyGoal: bodyGoal,
      dietaryRestrictions: dietaryRestrictions,
      allergies: allergies,
      dailyCalorieTarget: dailyCalorieTarget,
      useCalculatedTDEE: useCalculatedTDEE,
      medicalConditions: medicalConditions,
    );
  }
}
