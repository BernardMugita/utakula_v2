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
  final Map<String, NutrientBreakdown> breakDown;

  const CalorieModel({
    required this.id,
    required this.foodId,
    required this.total,
    required this.breakDown,
  });

  factory CalorieModel.fromJson(Map<String, dynamic> json) {
    final breakdown = json['breakdown'] as Map<String, dynamic>?;

    return CalorieModel(
      // Handle both 'calorie_id' and 'id' fields
      id: (json['calorie_id'] ?? json['id']) as String,
      foodId: json['food_id'] as String,
      total: json['total'] as int,
      breakDown: {
        if (breakdown != null && breakdown.containsKey('carbohydrate'))
          'carbohydrate': NutrientBreakdown.fromJson(breakdown['carbohydrate']),
        if (breakdown != null && breakdown.containsKey('protein'))
          'protein': NutrientBreakdown.fromJson(breakdown['protein']),
        if (breakdown != null && breakdown.containsKey('fat'))
          'fat': NutrientBreakdown.fromJson(breakdown['fat']),
        if (breakdown != null && breakdown.containsKey('fiber'))
          'fiber': NutrientBreakdown.fromJson(breakdown['fiber']),
      },
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calorie_id': id,
      'food_id': foodId,
      'total': total,
      'breakdown': {
        'carbohydrate': breakDown['carbohydrate']?.toJson(),
        'protein': breakDown['protein']?.toJson(),
        'fat': breakDown['fat']?.toJson(),
        'fiber': breakDown['fiber']?.toJson(),
      },
    };
  }

  factory CalorieModel.fromEntity(CalorieEntity entity) {
    return CalorieModel(
      id: entity.id,
      foodId: entity.foodId,
      total: entity.total,
      breakDown: {
        'carbohydrate': ?entity.breakDown['carbohydrate'],
        'protein': ?entity.breakDown['protein'],
        'fat': ?entity.breakDown['fat'],
        'fiber': ?entity.breakDown['fiber'],
      },
    );
  }

  CalorieEntity toEntity() {
    return CalorieEntity(
      id: id,
      foodId: foodId,
      total: total,
      breakDown: {
        'carbohydrate': ?breakDown['carbohydrate'],
        'protein': ?breakDown['protein'],
        'fat': ?breakDown['fat'],
        'fiber': ?breakDown['fiber'],
      },
    );
  }
}
