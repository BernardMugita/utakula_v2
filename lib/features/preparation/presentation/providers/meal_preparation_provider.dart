import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utakula_v2/core/network/dio_client.dart';
import 'package:utakula_v2/features/preparation/data/data_sources/meal_preparation_data_source.dart';
import 'package:utakula_v2/features/preparation/data/repository/meal_preparation_repository_impl.dart';
import 'package:utakula_v2/features/preparation/domain/repository/meal_preparation_repository.dart';
import 'package:utakula_v2/features/preparation/domain/use_cases/meal_preparation_use_cases.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(
    baseUrl: 'https://philanthropically-farsighted-malik.ngrok-free.dev',
  );
});

final mealPreparationRemoteDataSourceProvider =
    Provider<MealPreparationDataSource>((ref) {
      return MealPreparationDataSourceImpl(ref.read(dioClientProvider));
    });

final mealPreparationRepositoryProvider = Provider<MealPreparationRepository>((
  ref,
) {
  return MealPreparationRepositoryImpl(
    ref.read(mealPreparationRemoteDataSourceProvider),
  );
});

final getPreparationInstructionsProvider = Provider<GetPreparationInstructions>(
  (ref) {
    return GetPreparationInstructions(
      ref.read(mealPreparationRepositoryProvider),
    );
  },
);


