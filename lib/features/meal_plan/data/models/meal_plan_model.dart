import 'package:utakula_v2/features/meal_plan/domain/entities/day_meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/single_meal_plan_entity.dart';

class MealTypeFood {
  final String id;
  final String foodName;
  final String imageUrl;
  final int calories;

  MealTypeFood({
    required this.id,
    required this.foodName,
    required this.imageUrl,
    required this.calories,
  });

  factory MealTypeFood.fromJson(Map<String, dynamic> json) {
    return MealTypeFood(
      id: json['id'],
      foodName: json['name'],
      imageUrl: json['image_url'],
      calories: json['calories'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': foodName,
      'image_url': imageUrl,
      'calories': calories,
    };
  }

  factory MealTypeFood.fromEntity(MealTypeFoodEntity entity) {
    return MealTypeFood(
      id: entity.id,
      foodName: entity.foodName,
      imageUrl: entity.imageUrl,
      calories: entity.calories,
    );
  }

  MealTypeFoodEntity toEntity() {
    return MealTypeFoodEntity(
      id: id,
      foodName: foodName,
      imageUrl: imageUrl,
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
      breakfast:
          entity.breakfast.map((e) => MealTypeFood.fromEntity(e)).toList(),
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
  final int totalCalories;

  DayMealPlan({
    required this.day,
    required this.mealPlan,
    required this.totalCalories,
  });

  factory DayMealPlan.fromJson(Map<String, dynamic> json) {
    return DayMealPlan(
      day: json['day'],
      mealPlan: SingleMealPlan.fromJson(json['meal_plan']),
      totalCalories: json['total_calories'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'meal_plan': mealPlan.toJson(),
      'total_calories': totalCalories,
    };
  }

  factory DayMealPlan.fromEntity(DayMealPlanEntity entity) {
    return DayMealPlan(
      day: entity.day,
      mealPlan: SingleMealPlan.fromEntity(entity.mealPlan),
      totalCalories: entity.totalCalories,
    );
  }

  DayMealPlanEntity toEntity() {
    return DayMealPlanEntity(
      day: day,
      mealPlan: mealPlan.toEntity(),
      totalCalories: totalCalories,
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
