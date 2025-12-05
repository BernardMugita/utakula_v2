import 'package:utakula_v2/features/meal_plan/domain/entities/single_meal_plan_entity.dart';

class DayMealPlanEntity {
  final String day;
  final SingleMealPlanEntity mealPlan;
  final int totalCalories;

  DayMealPlanEntity({
    required this.day,
    required this.mealPlan,
    required this.totalCalories,
  });
}
