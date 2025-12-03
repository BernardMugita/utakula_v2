import 'package:utakula_v2/features/foods/domain/entities/calorie_entity.dart';

class NutrientBreakdown {
  final double amount;
  final double calories;
  final String unit;

  const NutrientBreakdown({
    required this.amount,
    required this.calories,
    required this.unit,
  });

  Map<String, dynamic> toJson() {
    return {'amount': amount, 'calories': calories, 'unit': unit};
  }

  factory NutrientBreakdown.fromJson(Map<String, dynamic> json) {
    return NutrientBreakdown(
      amount: (json['amount'] as num).toDouble(),
      calories: (json['calories'] as num).toDouble(),
      unit: json['unit'] as String,
    );
  }
}

class CalorieModel {
  final String id;
  final String foodId;
  final int total;
  final NutrientBreakdown? carbohydrate;
  final NutrientBreakdown? protein;
  final NutrientBreakdown? fat;
  final NutrientBreakdown? fiber;

  const CalorieModel({
    required this.id,
    required this.foodId,
    required this.total,
    this.carbohydrate,
    this.protein,
    this.fat,
    this.fiber,
  });

  factory CalorieModel.fromJson(Map<String, dynamic> json) {
    final breakdown = json['breakdown'] as Map<String, dynamic>?;

    return CalorieModel(
      // Handle both 'calorie_id' and 'id' fields
      id: (json['calorie_id'] ?? json['id']) as String,
      foodId: json['food_id'] as String,
      total: json['total'] as int,
      carbohydrate: breakdown?['carbohydrate'] != null
          ? NutrientBreakdown.fromJson(breakdown!['carbohydrate'])
          : null,
      protein: breakdown?['protein'] != null
          ? NutrientBreakdown.fromJson(breakdown!['protein'])
          : null,
      fat: breakdown?['fat'] != null
          ? NutrientBreakdown.fromJson(breakdown!['fat'])
          : null,
      fiber: breakdown?['fiber'] != null
          ? NutrientBreakdown.fromJson(breakdown!['fiber'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calorie_id': id,
      'food_id': foodId,
      'total': total,
      'breakdown': {
        if (carbohydrate != null) 'carbohydrate': carbohydrate!.toJson(),
        if (protein != null) 'protein': protein!.toJson(),
        if (fat != null) 'fat': fat!.toJson(),
        if (fiber != null) 'fiber': fiber!.toJson(),
      },
    };
  }

  factory CalorieModel.fromEntity(CalorieEntity entity) {
    return CalorieModel(
      id: entity.id,
      foodId: entity.foodId,
      total: entity.total,
      carbohydrate: entity.carbohydrate,
      protein: entity.protein,
      fat: entity.fat,
      fiber: entity.fiber,
    );
  }

  CalorieEntity toEntity() {
    return CalorieEntity(
      id: id,
      foodId: foodId,
      total: total,
      carbohydrate: carbohydrate,
      protein: protein,
      fat: fat,
      fiber: fiber,
    );
  }
}
