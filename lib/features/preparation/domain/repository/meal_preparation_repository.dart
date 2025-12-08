import 'package:dartz/dartz.dart';
import 'package:utakula_v2/core/error/failures.dart';
import 'package:utakula_v2/features/preparation/domain/entities/meal_preparation_entity.dart';

abstract class MealPreparationRepository {
  Future<Either<Failure, List<String>>> getPreparationInstructions(
    MealPreparationEntity mealPrepEntity,
  );
}
