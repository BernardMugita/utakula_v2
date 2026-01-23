import 'package:utakula_v2/features/meal_plan/domain/entities/single_meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/total_macros.dart';

class DayMealPlanEntity {
  final String day;
  final SingleMealPlanEntity mealPlan;
  final double totalCalories;
  final TotalMacros totalMacros;

  DayMealPlanEntity({
    required this.day,
    required this.mealPlan,
    required this.totalCalories,
    required this.totalMacros,
  });

  Map toJson() {
    return {
      'day': day,
      'mealPlan': mealPlan.toJson(),
      'totalCalories': totalCalories,
      'totalMacros': totalMacros.toJson(),
    };
  }
}
