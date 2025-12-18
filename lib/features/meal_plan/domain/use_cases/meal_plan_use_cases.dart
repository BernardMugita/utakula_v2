import 'package:dartz/dartz.dart';
import 'package:utakula_v2/core/error/failures.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/user_meal_plan_prefs_entity.dart';
import 'package:utakula_v2/features/meal_plan/domain/repositories/meal_plan_repository.dart';

class CreateMealPlan {
  final MealPlanRepository repository;

  CreateMealPlan(this.repository);

  Future<Either<Failure, MealPlanEntity>> call(MealPlanEntity mealPlan) async {
    return await repository.createMealPlan(mealPlan);
  }
}

class GetUserMealPlan {
  final MealPlanRepository repository;

  GetUserMealPlan(this.repository);

  Future<Either<Failure, MealPlanEntity>> call() async {
    return await repository.getUserMealPlan();
  }
}

class SuggestMealPlan {
  final MealPlanRepository repository;

  SuggestMealPlan(this.repository);

  Future<Either<Failure, MealPlanEntity>> call(
    UserMealPlanPrefsEntity prefsEntity,
  ) async {
    return await repository.suggestMealPlan(prefsEntity);
  }
}

class UpdateUserMealPlan {
  final MealPlanRepository repository;

  UpdateUserMealPlan(this.repository);

  Future<Either<Failure, MealPlanEntity>> call(MealPlanEntity mealPlan) async {
    return await repository.updateUserMealPlan(mealPlan);
  }
}
