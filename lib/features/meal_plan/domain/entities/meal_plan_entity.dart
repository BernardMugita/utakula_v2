import 'package:utakula_v2/features/meal_plan/domain/entities/day_meal_plan_entity.dart';

class MealPlanEntity {
  final String id;
  final List members;
  final List<DayMealPlanEntity> mealPlan;

  MealPlanEntity({
    required this.id,
    required this.members,
    required this.mealPlan,
  });
}