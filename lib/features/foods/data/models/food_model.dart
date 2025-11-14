import 'package:utakula_v2/features/foods/data/models/calorie_model.dart';
import 'package:utakula_v2/features/foods/domain/entities/meal_plan_enum.dart';

import '../../domain/entities/food_entity.dart';

class FoodModel {
  final String id;
  final String? imageUrl;
  final String name;
  final String macroNutrient;
  final MealTypeEnum mealType;
  final CalorieModel? calories;

  const FoodModel({
    required this.id,
    this.imageUrl,
    required this.name,
    required this.macroNutrient,
    required this.mealType,
    this.calories,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['food_id'] as String,
      imageUrl: json['image_url'] as String?,
      name: json['name'] as String,
      macroNutrient: json['macro_nutrient'] as String,
      mealType: MealTypeEnum.fromString(json['meal_type'] as String),
      calories: json['calories'] != null
          ? CalorieModel.fromJson(json['calories'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food_id': id,
      'image_url': imageUrl,
      'name': name,
      'macro_nutrient': macroNutrient,
      'meal_type': mealType.toJson(),
      'calories': calories?.toJson(),
    };
  }

  factory FoodModel.fromEntity(FoodEntity entity) {
    return FoodModel(
      id: entity.id,
      imageUrl: entity.imageUrl,
      name: entity.name,
      macroNutrient: entity.macroNutrient,
      mealType: entity.mealType,
      calories: entity.calories != null
          ? CalorieModel.fromEntity(entity.calories!)
          : null,
    );
  }

  FoodEntity toEntity() {
    return FoodEntity(
      id: id,
      imageUrl: imageUrl,
      name: name,
      macroNutrient: macroNutrient,
      mealType: mealType,
      calories: calories?.toEntity(),
    );
  }
}
