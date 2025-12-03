import 'package:utakula_v2/features/foods/data/models/calorie_model.dart';

class CalorieEntity {
  final String id;
  final String foodId;
  final int total;
  final NutrientBreakdown? carbohydrate;
  final NutrientBreakdown? protein;
  final NutrientBreakdown? fat;
  final NutrientBreakdown? fiber;

  const CalorieEntity({
    required this.id,
    required this.foodId,
    required this.total,
    this.carbohydrate,
    this.protein,
    this.fat,
    this.fiber,
  });

  CalorieEntity copyWith({
    String? id,
    String? foodId,
    int? total,
    NutrientBreakdown? carbohydrate,
    NutrientBreakdown? protein,
    NutrientBreakdown? fat,
    NutrientBreakdown? fiber,
  }) {
    return CalorieEntity(
      id: id ?? this.id,
      foodId: foodId ?? this.foodId,
      total: total ?? this.total,
      carbohydrate: carbohydrate ?? this.carbohydrate,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      fiber: fiber ?? this.fiber,
    );
  }
}