import 'package:utakula_v2/features/preparation/domain/entities/meal_preparation_entity.dart';

class MealPreparationModel {
  final List<String> foodList;

  MealPreparationModel({required this.foodList});

  factory MealPreparationModel.fromJson(Map<String, dynamic> json) {
    return MealPreparationModel(foodList: json['food_list'] as List<String>);
  }

  factory MealPreparationModel.fromEntity(MealPreparationEntity entity) {
    return MealPreparationModel(foodList: entity.foodList);
  }

  Map<String, dynamic> toJson() {
    return {'food_list': foodList};
  }

  MealPreparationEntity toEntity() {
    return MealPreparationEntity(foodList: foodList);
  }
}
