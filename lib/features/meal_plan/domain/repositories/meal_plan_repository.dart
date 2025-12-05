import 'package:dartz/dartz.dart';
import 'package:utakula_v2/core/error/failures.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/meal_plan_entity.dart';

abstract class MealPlanRepository {
  Future<Either<Failure, MealPlanEntity>> createMealPlan(
    MealPlanEntity mealPlanEntity,
  );
}
