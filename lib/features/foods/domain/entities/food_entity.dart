import 'package:utakula_v2/features/foods/domain/entities/meal_plan_enum.dart';
import 'calorie_entity.dart';

class FoodEntity {
  final String id;
  final String? imageUrl;
  final String name;
  final String macroNutrient;
  final MealTypeEnum mealType;
  final CalorieEntity? calories;

  const FoodEntity({
    required this.id,
    this.imageUrl,
    required this.name,
    required this.macroNutrient,
    required this.mealType,
    this.calories,
  });
}


