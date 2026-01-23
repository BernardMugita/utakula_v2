import 'package:utakula_v2/features/foods/domain/entities/meal_plan_enum.dart';
import 'calorie_entity.dart';

class FoodEntity {
  final String id;
  final String? imageUrl;
  final String name;
  final String macroNutrient;
  final MealTypeEnum mealType;
  final CalorieEntity? calories;
  final int referencePortionGrams;
  final List dietaryTags;
  final List<String> allergens;
  final List<String> suitableForConditions;

  const FoodEntity({
    required this.id,
    this.imageUrl,
    required this.name,
    required this.macroNutrient,
    required this.mealType,
    this.calories,
    this.referencePortionGrams = 100,
    this.dietaryTags = const [],
    this.allergens = const [],
    this.suitableForConditions = const [],
  });

  factory FoodEntity.fromJson(Map<String, dynamic> json) {
    return FoodEntity(
      id: json['id'],
      imageUrl: json['image_url'],
      name: json['name'],
      macroNutrient: json['macro_nutrient'],
      mealType: MealTypeEnum.values.firstWhere(
        (mealType) => mealType.name == json['meal_type'],
      ),
      calories: CalorieEntity.fromJson(json['calories']),
      referencePortionGrams: json['reference_portion_grams'],
      dietaryTags: List<String>.from(json['dietary_tags']),
      allergens: List<String>.from(json['allergens']),
      suitableForConditions: List<String>.from(json['suitable_for_conditions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'name': name,
      'macro_nutrient': macroNutrient,
      'meal_type': mealType.name,
      'calories': calories?.toJson(),
      'reference_portion_grams': referencePortionGrams,
      'dietary_tags': dietaryTags,
      'allergens': allergens,
      'suitable_for_conditions': suitableForConditions
    };
  }
}
