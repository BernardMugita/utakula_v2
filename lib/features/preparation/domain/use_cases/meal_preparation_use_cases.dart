import 'package:dartz/dartz.dart';
import 'package:utakula_v2/core/error/failures.dart';
import 'package:utakula_v2/features/preparation/domain/entities/meal_preparation_entity.dart';
import 'package:utakula_v2/features/preparation/domain/repository/meal_preparation_repository.dart';

class GetPreparationInstructions {
  final MealPreparationRepository repository;

  GetPreparationInstructions(this.repository);

  Future<Either<Failure, List<String>>> call(MealPreparationEntity mealPrepEntity) async {
    return await repository.getPreparationInstructions(mealPrepEntity);
  }
}
