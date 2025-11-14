import 'package:dartz/dartz.dart';
import 'package:utakula_v2/core/error/failures.dart';
import 'package:utakula_v2/features/foods/domain/entities/food_entity.dart';

abstract class FoodsRepository {
  Future<Either<Failure, FoodEntity>> createFood(FoodEntity foodEntity);

  Future<Either<Failure, List<FoodEntity>>> getAllFoods();

  Future<Either<Failure, FoodEntity>> getFoodById(String id);

  Future<Either<Failure, FoodEntity>> updateFood(FoodEntity foodEntity);

  Future<Either<Failure, void>> deleteFood(String id);
}
