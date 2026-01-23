import 'package:utakula_v2/features/foods/data/models/calorie_model.dart';

class CalorieEntity {
  final String id;
  final String foodId;
  final int total;
  final Map<String, NutrientBreakdown> breakDown;

  const CalorieEntity({
    required this.id,
    required this.foodId,
    required this.total,
    required this.breakDown,
  });

  CalorieEntity copyWith({
    String? id,
    String? foodId,
    int? total,
    Map<String, NutrientBreakdown>? breakDown,
  }) {
    return CalorieEntity(
      id: id ?? this.id,
      foodId: foodId ?? this.foodId,
      total: total ?? this.total,
      breakDown: breakDown ?? this.breakDown,
    );
  }

  factory CalorieEntity.fromJson(Map<String, dynamic> json) {
    return CalorieEntity(
      id: json['id'],
      foodId: json['food_id'],
      total: json['total'],
      breakDown: Map<String, NutrientBreakdown>.from(
        json['breakDown'].map(
          (key, value) => MapEntry(key, NutrientBreakdown.fromJson(value)),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'food_id': foodId,
      'total': total,
      'breakDown': breakDown.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}
