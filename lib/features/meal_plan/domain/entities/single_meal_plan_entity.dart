import 'package:utakula_v2/features/meal_plan/domain/entities/total_macros.dart';

class MealTypeFoodEntity {
  final String id;
  final String foodName;
  final String imageUrl;
  final double grams;
  final TotalMacros macros;
  final double servings;
  final double caloriesPer100G;
  final double calories;

  MealTypeFoodEntity({
    required this.id,
    required this.foodName,
    required this.imageUrl,
    required this.grams,
    required this.macros,
    required this.servings,
    required this.caloriesPer100G,
    required this.calories,
  });

  Map toJson() {
    return {
      'id': id,
      'foodName': foodName,
      'imageUrl': imageUrl,
      'grams': grams,
      'macros': macros.toJson(),
      'servings': servings,
      'caloriesPer100G': caloriesPer100G,
      'calories': calories,
    };
  }
}

class SingleMealPlanEntity {
  final List<MealTypeFoodEntity> breakfast;
  final List<MealTypeFoodEntity> lunch;
  final List<MealTypeFoodEntity> supper;

  SingleMealPlanEntity({
    required this.breakfast,
    required this.lunch,
    required this.supper,
  });

  Map toJson() {
    return {
      'breakfast': breakfast.map((food) => food.toJson()).toList(),
      'lunch': lunch.map((food) => food.toJson()).toList(),
      'supper': supper.map((food) => food.toJson()).toList(),
    };
  }
}
