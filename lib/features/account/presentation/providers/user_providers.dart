import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utakula_v2/core/network/api_endpoints.dart';
import 'package:utakula_v2/core/network/dio_client.dart';
import 'package:utakula_v2/core/network/exception_handler.dart';
import 'package:utakula_v2/features/account/data/data_sources/user_account_data_source.dart';
import 'package:utakula_v2/features/account/data/repositories/user_repository_impl.dart';
import 'package:utakula_v2/features/account/domain/entities/user_entity.dart';
import 'package:utakula_v2/features/account/domain/repositories/user_repository.dart';
import 'package:utakula_v2/features/account/domain/use_cases/user_use_cases.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(
    baseUrl: ApiEndpoints.productionURL
  );
});

final ExceptionHandler exceptionHandler = ExceptionHandler();

final userRemoteDataSourceProvider = Provider<UserAccountDataSource>((ref) {
  return UserAccountDataSourceImpl(
    ref.read(dioClientProvider),
    exceptionHandler,
  );
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(ref.read(userRemoteDataSourceProvider));
});

final getUserAccountDetailsProvider = Provider<GetUserAccountDetails>((ref) {
  return GetUserAccountDetails(ref.read(userRepositoryProvider));
});

final updateUserAccountDetailsProvider = Provider<UpdateUserAccountDetails>((
  ref,
) {
  return UpdateUserAccountDetails(ref.read(userRepositoryProvider));
});

class UserState {
  final bool isLoading;
  final bool isSubmitting;
  final UserEntity user;
  final String? errorMessage;

  const UserState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.user = const UserEntity(),
    this.errorMessage,
  });

  UserState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    UserEntity? user,
    String? errorMessage,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

class UserNotifier extends Notifier<UserState> {
  @override
  UserState build() {
    return const UserState();
  }

  Future<void> getUserAccountDetails() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final getUserAccountDetails = ref.read(getUserAccountDetailsProvider);
    final result = await getUserAccountDetails();
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (user) {
        state = state.copyWith(isLoading: false, user: user);
      },
    );
  }

  Future<void> updateUserAccountDetails(UserEntity userEntity) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    final updateUserAccountDetails = ref.read(updateUserAccountDetailsProvider);
    final result = await updateUserAccountDetails(userEntity);
    result.fold(
      (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        );
      },
      (user) {
        state = state.copyWith(isSubmitting: false, user: user);
      },
    );
  }
}

final userStateProvider = NotifierProvider<UserNotifier, UserState>(() {
  return UserNotifier();
});
