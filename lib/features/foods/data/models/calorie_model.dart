import 'package:utakula_v2/features/foods/domain/entities/calorie_entity.dart';

class CalorieModel {
  final String id;
  final String foodId;
  final int total;
  final Map<String, dynamic> breakdown;

  const CalorieModel({
    required this.id,
    required this.foodId,
    required this.total,
    required this.breakdown,
  });

  factory CalorieModel.fromJson(Map<String, dynamic> json) {
    return CalorieModel(
      id: json['calorie_id'] as String,
      foodId: json['food_id'] as String,
      total: json['total'] as int,
      breakdown: json['breakdown'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calorie_id': id,
      'food_id': foodId,
      'total': total,
      'breakdown': breakdown,
    };
  }

  factory CalorieModel.fromEntity(CalorieEntity entity) {
    return CalorieModel(
      id: entity.id,
      foodId: entity.foodId,
      total: entity.total,
      breakdown: entity.breakdown,
    );
  }

  CalorieEntity toEntity() {
    return CalorieEntity(
      id: id,
      foodId: foodId,
      total: total,
      breakdown: breakdown,
    );
  }
}
