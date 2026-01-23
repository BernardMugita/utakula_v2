import 'package:utakula_v2/features/meal_plan/domain/entities/day_meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/single_meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/total_macros.dart';

class MealTypeFood {
  final String id;
  final String foodName;
  final String imageUrl;
  final double grams;
  final TotalMacros macros;
  final double servings;
  final double caloriesPer100G;
  final double calories;

  MealTypeFood({
    required this.id,
    required this.foodName,
    required this.imageUrl,
    required this.grams,
    required this.macros,
    required this.servings,
    required this.caloriesPer100G,
    required this.calories,
  });

  factory MealTypeFood.fromJson(Map<String, dynamic> json) {
    return MealTypeFood(
      id: json['id'],
      foodName: json['name'],
      imageUrl: json['image_url'],
      grams: (json['grams'] as num).toDouble(),
      // Handle int/double conversion
      macros: TotalMacros(
        proteinGrams: (json['macros']!['protein_g'] as num).toDouble(),
        carbohydrateGrams: (json['macros']!['carbs_g'] as num).toDouble(),
        fatGrams: (json['macros']!['fat_g'] as num).toDouble(),
        fibreGrams: (json['macros']!['fiber_g'] as num)
            .toDouble(), // Note: fiber_g not fibre_g
      ),
      servings: (json['servings'] as num).toDouble(),
      caloriesPer100G: (json['calories_per_100g'] as num).toDouble(),
      calories: (json['total_calories'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': foodName,
      'image_url': imageUrl,
      'grams': grams,
      'macros': macros.toJson(),
      'servings': servings,
      'calories_per_100g': caloriesPer100G,
      'total_calories': calories,
    };
  }

  factory MealTypeFood.fromEntity(MealTypeFoodEntity entity) {
    return MealTypeFood(
      id: entity.id,
      foodName: entity.foodName,
      imageUrl: entity.imageUrl,
      grams: entity.grams,
      macros: TotalMacros(
        proteinGrams: entity.macros.proteinGrams,
        carbohydrateGrams: entity.macros.carbohydrateGrams,
        fatGrams: entity.macros.fatGrams,
        fibreGrams: entity.macros.fibreGrams,
      ),
      servings: entity.servings,
      caloriesPer100G: entity.caloriesPer100G,
      calories: entity.calories,
    );
  }

  MealTypeFoodEntity toEntity() {
    return MealTypeFoodEntity(
      id: id,
      foodName: foodName,
      imageUrl: imageUrl,
      grams: grams,
      macros: TotalMacros(
        proteinGrams: macros.proteinGrams,
        carbohydrateGrams: macros.carbohydrateGrams,
        fatGrams: macros.fatGrams,
        fibreGrams: macros.fibreGrams,
      ),
      servings: servings,
      caloriesPer100G: caloriesPer100G,
      calories: calories,
    );
  }
}

class SingleMealPlan {
  final List<MealTypeFood> breakfast;
  final List<MealTypeFood> lunch;
  final List<MealTypeFood> supper;

  SingleMealPlan({
    required this.breakfast,
    required this.lunch,
    required this.supper,
  });

  factory SingleMealPlan.fromJson(Map<String, dynamic> json) {
    return SingleMealPlan(
      breakfast: (json['breakfast'] as List<dynamic>)
          .map((food) => MealTypeFood.fromJson(food))
          .toList(),
      lunch: (json['lunch'] as List<dynamic>)
          .map((food) => MealTypeFood.fromJson(food))
          .toList(),
      supper: (json['supper'] as List<dynamic>)
          .map((food) => MealTypeFood.fromJson(food))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'breakfast': breakfast.map((food) => food.toJson()).toList(),
      'lunch': lunch.map((food) => food.toJson()).toList(),
      'supper': supper.map((food) => food.toJson()).toList(),
    };
  }

  factory SingleMealPlan.fromEntity(SingleMealPlanEntity entity) {
    return SingleMealPlan(
      breakfast: entity.breakfast
          .map((e) => MealTypeFood.fromEntity(e))
          .toList(),
      lunch: entity.lunch.map((e) => MealTypeFood.fromEntity(e)).toList(),
      supper: entity.supper.map((e) => MealTypeFood.fromEntity(e)).toList(),
    );
  }

  SingleMealPlanEntity toEntity() {
    return SingleMealPlanEntity(
      breakfast: breakfast.map((m) => m.toEntity()).toList(),
      lunch: lunch.map((m) => m.toEntity()).toList(),
      supper: supper.map((m) => m.toEntity()).toList(),
    );
  }
}

class DayMealPlan {
  final String day;
  final SingleMealPlan mealPlan;
  final double totalCalories;
  final TotalMacros totalMacros;

  DayMealPlan({
    required this.day,
    required this.mealPlan,
    required this.totalCalories,
    required this.totalMacros,
  });

  factory DayMealPlan.fromJson(Map<String, dynamic> json) {
    return DayMealPlan(
      day: json['day'],
      mealPlan: SingleMealPlan.fromJson(json['meal_plan']),
      totalCalories: (json['total_calories'] as num).toDouble(),
      // Handle int/double conversion
      totalMacros: TotalMacros(
        proteinGrams: (json['total_macros']!['protein_g'] as num).toDouble(),
        carbohydrateGrams: (json['total_macros']!['carbs_g'] as num).toDouble(),
        fatGrams: (json['total_macros']!['fat_g'] as num).toDouble(),
        fibreGrams: (json['total_macros']!['fiber_g'] as num)
            .toDouble(), // Changed from 'fibre_g' to 'fiber_g'
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'meal_plan': mealPlan.toJson(),
      'total_calories': totalCalories,
      'total_macros': totalMacros.toJson(),
      // Added this so it's included in JSON output
    };
  }

  factory DayMealPlan.fromEntity(DayMealPlanEntity entity) {
    return DayMealPlan(
      day: entity.day,
      mealPlan: SingleMealPlan.fromEntity(entity.mealPlan),
      totalCalories: entity.totalCalories,
      totalMacros: entity.totalMacros,
    );
  }

  DayMealPlanEntity toEntity() {
    return DayMealPlanEntity(
      day: day,
      mealPlan: mealPlan.toEntity(),
      totalCalories: totalCalories,
      totalMacros: totalMacros,
    );
  }
}

class MealPlanModel {
  final String id;
  final List members;
  final List<DayMealPlan> mealPlan;

  MealPlanModel({
    required this.mealPlan,
    required this.id,
    required this.members,
  });

  factory MealPlanModel.fromJson(Map<String, dynamic> json) {
    return MealPlanModel(
      id: json['id'],
      members: json['members'],
      mealPlan: (json['meal_plan'] as List<dynamic>)
          .map((plan) => DayMealPlan.fromJson(plan))
          .toList(),
    );
  }

  factory MealPlanModel.fromEntity(MealPlanEntity entity) {
    return MealPlanModel(
      id: entity.id,
      members: entity.members,
      mealPlan: entity.mealPlan
          .map((plan) => DayMealPlan.fromEntity(plan))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'members': members,
      'meal_plan': mealPlan.map((plan) => plan.toJson()).toList(),
    };
  }

  MealPlanEntity toEntity() {
    return MealPlanEntity(
      id: id,
      members: members,
      mealPlan: mealPlan.map((plan) => plan.toEntity()).toList(),
    );
  }
}
