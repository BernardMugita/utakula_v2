import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/features/preparation/domain/entities/meal_preparation_entity.dart';
import 'package:utakula_v2/features/preparation/presentation/providers/meal_preparation_provider.dart';
import 'package:utakula_v2/features/preparation/presentation/providers/meal_preparation_state.dart';

class MealPreparationNotifier extends Notifier<MealPreparationState> {
  @override
  MealPreparationState build() {
    return const MealPreparationState();
  }

  final Logger logger = Logger();

  // --------------------------------------------------------
  // Fetch preparation instructions for a list of foods
  // --------------------------------------------------------

  Future<List<String>> fetchPreparationInstructions(
    MealPreparationEntity mealPrepEntity,
  ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await ref
        .read(getPreparationInstructionsProvider)
        .call(mealPrepEntity);

    logger.d(result);

    return result.fold(
      (failure) {
        logger.e(
          'Failed to fetch preparation instructions: ${failure.message}',
        );
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return [];
      },
      (instructions) {
        logger.i('Preparation instructions fetched successfully');
        state = state.copyWith(isLoading: false, instructions: instructions);
        return instructions;
      },
    );
  }
}

final mealPreparationStateProvider =
    NotifierProvider<MealPreparationNotifier, MealPreparationState>(() {
      return MealPreparationNotifier();
    });
