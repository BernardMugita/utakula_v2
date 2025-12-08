import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/core/error/exceptions.dart';
import 'package:utakula_v2/core/error/failures.dart';
import 'package:utakula_v2/features/preparation/data/data_sources/meal_preparation_data_source.dart';
import 'package:utakula_v2/features/preparation/domain/entities/meal_preparation_entity.dart';
import 'package:utakula_v2/features/preparation/domain/repository/meal_preparation_repository.dart';

class MealPreparationRepositoryImpl implements MealPreparationRepository {
  final MealPreparationDataSource mealPreparationDataSource;
  Logger logger = Logger();

  MealPreparationRepositoryImpl(this.mealPreparationDataSource);

  @override
  Future<Either<Failure, List<String>>> getPreparationInstructions(
    MealPreparationEntity mealPrepEntity,
  ) async {
    try {
      final result = await mealPreparationDataSource.getPreparationInstructions(
        mealPrepEntity,
      );

      logger.d(result);

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
