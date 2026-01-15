import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/core/network/api_endpoints.dart';
import 'package:utakula_v2/core/network/dio_client.dart';
import 'package:utakula_v2/features/foods/data/data_sources/foods_data_source.dart';
import 'package:utakula_v2/features/foods/data/repositories/foods_repository_impl.dart';
import 'package:utakula_v2/features/foods/domain/entities/food_entity.dart';
import 'package:utakula_v2/features/foods/domain/repositories/foods_repository.dart';
import 'package:utakula_v2/features/foods/domain/usecases/foods_use_case.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(
    baseUrl: ApiEndpoints.productionURL
  );
});

final foodRemoteDataSourceProvider = Provider<FoodRemoteDataSource>((ref) {
  return FoodRemoteDataSourceImpl(ref.read(dioClientProvider));
});

final foodsRepositoryProvider = Provider<FoodsRepository>((ref) {
  return FoodRepositoryImpl(ref.read(foodRemoteDataSourceProvider));
});

final getFoodsProvider = Provider<GetFoods>((ref) {
  return GetFoods(ref.read(foodsRepositoryProvider));
});

final getFoodByIdProvider = Provider<GetFoodById>((ref) {
  return GetFoodById(ref.read(foodsRepositoryProvider));
});

final createFoodProvider = Provider<CreateFood>((ref) {
  return CreateFood(ref.read(foodsRepositoryProvider));
});

final updateFoodProvider = Provider<UpdateFood>((ref) {
  return UpdateFood(ref.read(foodsRepositoryProvider));
});

final deleteFoodProvider = Provider<DeleteFood>((ref) {
  return DeleteFood(ref.read(foodsRepositoryProvider));
});

class FoodState {
  final bool isLoading;
  final bool isSubmitting;
  final List<FoodEntity> foods;
  final List<FoodEntity> searchResults;
  final String? errorMessage;
  final bool resultsFound;

  const FoodState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.foods = const [],
    this.searchResults = const [],
    this.errorMessage,
    this.resultsFound = true,
  });

  FoodState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<FoodEntity>? foods,
    List<FoodEntity>? searchResults,
    String? errorMessage,
    bool? resultsFound,
  }) {
    return FoodState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      foods: foods ?? this.foods,
      searchResults: searchResults ?? this.searchResults,
      errorMessage: errorMessage,
      resultsFound: resultsFound ?? this.resultsFound,
    );
  }
}

class FoodNotifier extends Notifier<FoodState> {
  @override
  FoodState build() {
    return const FoodState();
  }

  Logger logger = Logger();

  Future<void> createFood(FoodEntity foodEntity) async {
    logger.d(foodEntity);
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    final createFood = ref.read(createFoodProvider);
    final result = await createFood(foodEntity);
    result.fold(
      (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        );
      },
      (food) {
        state = state.copyWith(
          isSubmitting: false,
          foods: [...state.foods, food],
        );
      },
    );
  }

  Future<void> fetchFoods() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final getFoods = ref.read(getFoodsProvider);
    final result = await getFoods();
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (foods) {
        state = state.copyWith(isLoading: false, foods: foods);
      },
    );
  }

  void searchFoods(String query) {
    if (query.isEmpty) {
      state = state.copyWith(searchResults: state.foods, resultsFound: true);
    } else {
      final results = state.foods
          .where(
            (food) => food.name.toUpperCase().contains(query.toUpperCase()),
          )
          .toList();
      state = state.copyWith(
        searchResults: results,
        resultsFound: results.isNotEmpty,
      );
    }
  }
}

final foodStateProvider = NotifierProvider<FoodNotifier, FoodState>(() {
  return FoodNotifier();
});
