import 'package:dartz/dartz.dart';
import 'package:utakula_v2/features/foods/data/data_sources/foods_data_source.dart';
import 'package:utakula_v2/features/foods/domain/repositories/foods_repository.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/food_entity.dart';

class FoodRepositoryImpl implements FoodsRepository {
  final FoodRemoteDataSource remoteDataSource;

  FoodRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, FoodEntity>> createFood(FoodEntity foodEntity) async {
    try {
      final result = await remoteDataSource.createFood(foodEntity);
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
  Future<Either<Failure, List<FoodEntity>>> getAllFoods() async {
    try {
      final result = await remoteDataSource.getAllFoods();
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
  Future<Either<Failure, FoodEntity>> getFoodById(String id) async {
    try {
      final result = await remoteDataSource.getFoodById(id);
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
  Future<Either<Failure, FoodEntity>> updateFood(FoodEntity foodEntity) async {
    try {
      final result = await remoteDataSource.updateFood(foodEntity);
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
  Future<Either<Failure, void>> deleteFood(String id) async {
    try {
      final result = await remoteDataSource.deleteFood(id);
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
