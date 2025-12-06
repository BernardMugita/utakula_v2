import 'package:dartz/dartz.dart';
import 'package:utakula_v2/core/error/exceptions.dart';
import 'package:utakula_v2/core/error/failures.dart';
import 'package:utakula_v2/features/meal_plan/data/data_sources/meal_plan_data_source.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/domain/repositories/meal_plan_repository.dart';

class MealPlanRepositoryImpl implements MealPlanRepository {
  final MealPlanDataSource mealPlanDataSource;

  MealPlanRepositoryImpl(this.mealPlanDataSource);

  @override
  Future<Either<Failure, MealPlanEntity>> createMealPlan(
    MealPlanEntity mealPlanEntity,
  ) async {
    try {
      final result = await mealPlanDataSource.createMealPlan(mealPlanEntity);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<Either<Failure, MealPlanEntity>> getUserMealPlan(

  ) async {
    try {
      final result = await mealPlanDataSource.getUserMealPlan();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }
}
