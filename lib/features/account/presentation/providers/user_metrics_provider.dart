import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utakula_v2/core/network/api_endpoints.dart';
import 'package:utakula_v2/core/network/dio_client.dart';
import 'package:utakula_v2/core/network/exception_handler.dart';
import 'package:utakula_v2/features/account/data/data_sources/user_metrics_data_source.dart';
import 'package:utakula_v2/features/account/data/repositories/user_metrics_repository_impl.dart';
import 'package:utakula_v2/features/account/domain/entities/user_metrics_entity.dart';
import 'package:utakula_v2/features/account/domain/repositories/user_metrics_repository.dart';
import 'package:utakula_v2/features/account/domain/use_cases/user_metrics_use_cases.dart';

// Providers
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(baseUrl: ApiEndpoints.productionURL);
});

final exceptionHandlerProvider = Provider<ExceptionHandler>((ref) {
  return ExceptionHandler();
});

final userMetricsRemoteDataSourceProvider = Provider<UserMetricsDataSource>((
  ref,
) {
  return UserMetricsDataSourceImpl(
    ref.read(dioClientProvider),
    ref.read(exceptionHandlerProvider),
  );
});

final userMetricsRepositoryProvider = Provider<UserMetricsRepository>((ref) {
  return UserMetricsRepositoryImpl(
    ref.read(userMetricsRemoteDataSourceProvider),
  );
});

final createUserMetricsProvider = Provider<CreateUserMetrics>((ref) {
  return CreateUserMetrics(ref.read(userMetricsRepositoryProvider));
});

final getUserMetricsProvider = Provider<GetUserMetrics>((ref) {
  return GetUserMetrics(ref.read(userMetricsRepositoryProvider));
});

final updateUserMetricsProvider = Provider<UpdateUserMetrics>((ref) {
  return UpdateUserMetrics(ref.read(userMetricsRepositoryProvider));
});

// State Class
class UserMetricsState {
  final bool isLoading;
  final bool isSubmitting;
  final UserMetricsEntity? userMetrics;
  final String? errorMessage;
  final String? successMessage;

  const UserMetricsState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.userMetrics,
    this.errorMessage,
    this.successMessage,
  });

  UserMetricsState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    UserMetricsEntity? userMetrics,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return UserMetricsState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      userMetrics: userMetrics ?? this.userMetrics,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
    );
  }

  // Helper getters
  bool get hasMetrics => userMetrics != null;
}

// Notifier
class UserMetricsNotifier extends Notifier<UserMetricsState> {
  @override
  UserMetricsState build() {
    return const UserMetricsState();
  }

  Future<bool> createUserMetrics(UserMetricsEntity userMetricsEntity) async {
    state = state.copyWith(
      isSubmitting: true,
      clearError: true,
      clearSuccess: true,
    );

    final createUserMetrics = ref.read(createUserMetricsProvider);
    final result = await createUserMetrics(userMetricsEntity);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (userMetrics) {
        state = state.copyWith(
          isSubmitting: false,
          userMetrics: userMetrics,
          successMessage: 'Metrics created successfully',
        );
        return true;
      },
    );
  }

  Future<void> getUserMetrics() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final getUserMetrics = ref.read(getUserMetricsProvider);
    final result = await getUserMetrics();

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (userMetrics) {
        state = state.copyWith(isLoading: false, userMetrics: userMetrics);
      },
    );
  }

  Future<bool> updateUserMetrics(UserMetricsEntity userMetricsEntity) async {
    state = state.copyWith(
      isSubmitting: true,
      clearError: true,
      clearSuccess: true,
    );

    final updateUserMetrics = ref.read(updateUserMetricsProvider);
    final result = await updateUserMetrics(userMetricsEntity);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (userMetrics) {
        state = state.copyWith(
          isSubmitting: false,
          userMetrics: userMetrics,
          successMessage: 'Metrics updated successfully',
        );
        return true;
      },
    );
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void clearSuccess() {
    state = state.copyWith(clearSuccess: true);
  }
}

final userMetricsStateProvider =
    NotifierProvider<UserMetricsNotifier, UserMetricsState>(() {
      return UserMetricsNotifier();
    });
