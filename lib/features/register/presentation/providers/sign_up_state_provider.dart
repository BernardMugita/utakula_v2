import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utakula_v2/features/register/domain/entities/new_user.dart';
import 'package:utakula_v2/features/register/presentation/providers/sign_up_provider.dart';

class RegisterState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final Map<String, dynamic>? userData;

  const RegisterState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.userData,
  });

  RegisterState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    Map<String, dynamic>? userData,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      userData: userData ?? this.userData,
    );
  }
}

class RegisterNotifier extends Notifier<RegisterState> {
  @override
  RegisterState build() {
    return const RegisterState();
  }

  Future<void> registerUser(
    String username,
    String email,
    String password,
  ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final registerUserUseCase = ref.read(registerUserUseCaseProvider);

    final userEntity = NewUserEntity(
      username: username,
      email: email,
      password: password,
    );

    final result = await registerUserUseCase(userEntity);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          isSuccess: false,
        );
      },
      (userDate) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          userData: userDate,
          errorMessage: null,
        );
      },
    );
  }
}
