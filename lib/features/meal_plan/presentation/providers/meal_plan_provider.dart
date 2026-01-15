import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/core/network/api_endpoints.dart';
import 'package:utakula_v2/core/network/dio_client.dart';
import 'package:utakula_v2/features/meal_plan/data/data_sources/meal_plan_data_source.dart';
import 'package:utakula_v2/features/meal_plan/data/repositories/meal_plan_repository_impl.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/user_meal_plan_prefs_entity.dart';
import 'package:utakula_v2/features/meal_plan/domain/repositories/meal_plan_repository.dart';
import 'package:utakula_v2/features/meal_plan/domain/use_cases/meal_plan_use_cases.dart';

// Dio Client Provider (if not already in a shared file)
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(
    baseUrl: ApiEndpoints.productionURL
  );
});

// Data Source Provider
final mealPlanRemoteDataSourceProvider = Provider<MealPlanDataSource>((ref) {
  return MealPlanDataSourceImpl(ref.read(dioClientProvider));
});

// Repository Provider
final mealPlanRepositoryProvider = Provider<MealPlanRepository>((ref) {
  return MealPlanRepositoryImpl(ref.read(mealPlanRemoteDataSourceProvider));
});

// Use Case Providers
final createMealPlanProvider = Provider<CreateMealPlan>((ref) {
  return CreateMealPlan(ref.read(mealPlanRepositoryProvider));
});

final getMealPlanProvider = Provider<GetUserMealPlan>((ref) {
  return GetUserMealPlan(ref.read(mealPlanRepositoryProvider));
});

final suggestMealPlanProvider = Provider<SuggestMealPlan>((ref) {
  return SuggestMealPlan(ref.read(mealPlanRepositoryProvider));
});

final updateMealPlanProvider = Provider<UpdateUserMealPlan>((ref) {
  return UpdateUserMealPlan(ref.read(mealPlanRepositoryProvider));
});

// final deleteMealPlanProvider = Provider<DeleteMealPlan>((ref) {
//   return DeleteMealPlan(ref.read(mealPlanRepositoryProvider));
// });
//
// final getMemberMealPlansProvider = Provider<GetMemberMealPlans>((ref) {
//   return GetMemberMealPlans(ref.read(mealPlanRepositoryProvider));
// });

// State Class
class MealPlanState {
  final bool isLoading;
  final bool isSubmitting;
  final MealPlanEntity? currentMealPlan;
  final List<MealPlanEntity> memberMealPlans;
  final String? errorMessage;
  final String? successMessage;

  const MealPlanState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.currentMealPlan,
    this.memberMealPlans = const [],
    this.errorMessage,
    this.successMessage,
  });

  MealPlanState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    MealPlanEntity? currentMealPlan,
    List<MealPlanEntity>? memberMealPlans,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return MealPlanState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      currentMealPlan: currentMealPlan ?? this.currentMealPlan,
      memberMealPlans: memberMealPlans ?? this.memberMealPlans,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
    );
  }
}

// State Notifier
class MealPlanNotifier extends Notifier<MealPlanState> {
  @override
  MealPlanState build() {
    return const MealPlanState();
  }

  final Logger logger = Logger();

  // ---------------------------------------------------------------------------
  // Create a new meal plan
  // ---------------------------------------------------------------------------

  Future<bool> createMealPlan(MealPlanEntity mealPlanEntity) async {
    state = state.copyWith(
      isSubmitting: true,
      errorMessage: null,
      successMessage: null,
      clearError: true,
      clearSuccess: true,
    );

    final result = await ref.read(createMealPlanProvider).call(mealPlanEntity);

    return result.fold(
      (failure) {
        logger.e('Failed to create meal plan: ${failure.message}');
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (mealPlan) {
        logger.i('Meal plan created successfully');
        state = state.copyWith(
          isSubmitting: false,
          currentMealPlan: mealPlan,
          successMessage: 'Meal plan created successfully',
        );
        return true;
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Fetch the current user's meal plan
  // ---------------------------------------------------------------------------

  Future<void> fetchMealPlan() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      clearError: true,
    );

    final getMealPlan = ref.read(getMealPlanProvider);
    final result = await getMealPlan();

    result.fold(
      (failure) {
        logger.e('Failed to fetch meal plan: ${failure.message}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          currentMealPlan: MealPlanEntity(id: "", members: [], mealPlan: []),
        );
      },
      (mealPlan) {
        logger.i('Meal plan fetched successfully');
        state = state.copyWith(isLoading: false, currentMealPlan: mealPlan);
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Suggest a meal plan
  // ---------------------------------------------------------------------------

  Future<MealPlanEntity?> suggestMealPlan(
    UserMealPlanPrefsEntity prefsEntity,
  ) async {
    state = state.copyWith(
      isSubmitting: true,
      errorMessage: null,
      successMessage: null,
      clearError: true,
      clearSuccess: true,
    );

    final suggestMealPlan = ref.read(suggestMealPlanProvider);
    final result = await suggestMealPlan(prefsEntity);

    return result.fold(
      (failure) {
        logger.e('Failed to suggest meal plan: ${failure.message}');
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        );
        return null;
      },
      (suggestedMealPlan) {
        logger.i('Meal plan suggested successfully ${suggestedMealPlan.mealPlan}');
        // Do NOT update state here. Just return the entity.
        state = state.copyWith(isSubmitting: false);
        return suggestedMealPlan;
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Update the current meal plan
  // ---------------------------------------------------------------------------
  Future<bool> updateMealPlan(MealPlanEntity mealPlanEntity) async {
    state = state.copyWith(
      isSubmitting: true,
      errorMessage: null,
      successMessage: null,
      clearError: true,
      clearSuccess: true,
    );

    final updateMealPlan = ref.read(updateMealPlanProvider);
    final result = await updateMealPlan(mealPlanEntity);

    return result.fold(
      (failure) {
        logger.e('Failed to update meal plan: ${failure.message}');
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (mealPlan) {
        logger.i('Meal plan updated successfully');
        state = state.copyWith(
          isSubmitting: false,
          currentMealPlan: mealPlan,
          successMessage: 'Meal plan updated successfully',
        );
        return true;
      },
    );
  }

  // /// Delete the current meal plan
  // Future<bool> deleteMealPlan() async {
  //   state = state.copyWith(
  //     isSubmitting: true,
  //     errorMessage: null,
  //     clearError: true,
  //   );
  //
  //   final deleteMealPlan = ref.read(deleteMealPlanProvider);
  //   final result = await deleteMealPlan();
  //
  //   return result.fold(
  //         (failure) {
  //       logger.e('Failed to delete meal plan: ${failure.message}');
  //       state = state.copyWith(
  //         isSubmitting: false,
  //         errorMessage: failure.message,
  //       );
  //       return false;
  //     },
  //         (success) {
  //       logger.i('Meal plan deleted successfully');
  //       state = state.copyWith(
  //         isSubmitting: false,
  //         currentMealPlan: null,
  //         successMessage: 'Meal plan deleted successfully',
  //       );
  //       return true;
  //     },
  //   );
  // }
  //
  // /// Fetch meal plans shared with the user
  // Future<void> fetchMemberMealPlans() async {
  //   state = state.copyWith(
  //     isLoading: true,
  //     errorMessage: null,
  //     clearError: true,
  //   );
  //
  //   final getMemberMealPlans = ref.read(getMemberMealPlansProvider);
  //   final result = await getMemberMealPlans();
  //
  //   result.fold(
  //         (failure) {
  //       logger.e('Failed to fetch member meal plans: ${failure.message}');
  //       state = state.copyWith(
  //         isLoading: false,
  //         errorMessage: failure.message,
  //       );
  //     },
  //         (mealPlans) {
  //       logger.i('Member meal plans fetched successfully');
  //       state = state.copyWith(
  //         isLoading: false,
  //         memberMealPlans: mealPlans,
  //       );
  //     },
  //   );
  // }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null, clearError: true);
  }

  /// Clear success message
  void clearSuccess() {
    state = state.copyWith(successMessage: null, clearSuccess: true);
  }

  /// Clear current meal plan (for creating new one)
  void clearCurrentMealPlan() {
    state = state.copyWith(currentMealPlan: null);
    logger.log(Level.info, state.currentMealPlan);
  }
}

// State Provider
final mealPlanStateProvider = NotifierProvider<MealPlanNotifier, MealPlanState>(
  () {
    return MealPlanNotifier();
  },
);
