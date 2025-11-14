import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/core/providers/session_provider/session_state_provider.dart';
import 'package:utakula_v2/features/login/presentation/providers/sign_in_provider.dart';
import '../../domain/entities/auth_user.dart';

// State class - SAME
class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final Map<String, dynamic>? userData;

  const LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.userData,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    Map<String, dynamic>? userData,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      userData: userData ?? this.userData,
    );
  }
}

// ✅ Change from StateNotifier to Notifier
class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() {
    return const LoginState();
  }

  Logger logger = Logger();

  Future<void> signIn(String usernameOrEmail, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final authorizeUserUseCase = ref.read(authorizeUserUseCaseProvider);

    final userEntity = AuthUserEntity(
      usernameOrEmail: usernameOrEmail,
      password: password,
    );

    final result = await authorizeUserUseCase(userEntity);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          isSuccess: false,
        );
      },
      (userData) {
        logger.log(Level.info, userData);
        ref
            .read(sessionStateProvider.notifier)
            .login(userData['payload'] as String);
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          userData: userData,
          errorMessage: null,
        );
      },
    );
  }

  void reset() {
    state = const LoginState();
  }
}
