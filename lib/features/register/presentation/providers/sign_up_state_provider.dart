import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/common/helpers/app_secrets.dart';
import 'package:utakula_v2/core/providers/session_provider/session_state_provider.dart';
import 'package:utakula_v2/features/register/domain/entities/google_user_entity.dart';
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

  final _googleSignIn = GoogleSignIn.instance;
  bool _isInitialized = false;

  Logger logger = Logger();
  AppSecrets appSecrets = AppSecrets();

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      try {
        // Initialize with scopes if needed
        await _googleSignIn.initialize(serverClientId: appSecrets.clientId);
        _isInitialized = true;
      } catch (e) {
        print("Google Sign-In initialization failed: $e");
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to initialize Google Sign-In: $e',
        );
        rethrow;
      }
    }
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
      (userData) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          userData: userData,
          errorMessage: null,
        );
      },
    );
  }

  Future<GoogleSignInAccount?> signUpWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      logger.i("===== STEP 1: Ensuring initialization =====");
      await _ensureInitialized();

      logger.i("===== STEP 2: Starting authentication =====");

      final GoogleSignInAccount account = await _googleSignIn.authenticate();

      logger.i("===== STEP 3: Account obtained: ${account.email} =====");

      // Get scopes-based access token (for Google API calls)
      final scopes = <String>[
        "https://www.googleapis.com/auth/userinfo.email",
        "https://www.googleapis.com/auth/userinfo.profile",
      ];

      final auth = await account.authorizationClient.authorizationForScopes(
        scopes,
      );
      String? accessToken = auth?.accessToken;

      logger.i("===== STEP 4: Access token obtained =====");

      // THIS IS THE KEY - Get ID Token separately using authentication
      final GoogleSignInAuthentication authentication =
          await account.authentication;
      String? idToken = authentication.idToken;

      logger.i("===== STEP 5: ID token obtained =====");

      // Validate ID token (this is what backend needs)
      if (idToken == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to get ID token from Google',
          isSuccess: false,
        );
        return null;
      }

      logger.i("===== STEP 6: Sending to backend =====");
      logger.i("ID Token prefix: ${idToken.substring(0, 50)}...");
      logger.i("Access Token prefix: $accessToken");

      // Send ID TOKEN to backend (not access token)
      final userEntity = GoogleUserEntity(
        name: account.displayName ?? '',
        sub: account.id,
        email: account.email,
        token: idToken, // Use idToken here, not accessToken
      );

      logger.i("===== STEP 7: Calling use case =====");

      final signUpWithGoogleUseCase = ref.read(signUpWithGoogleProvider);
      final result = await signUpWithGoogleUseCase(userEntity);

      logger.i("===== STEP 8: Backend response received =====");

      result.fold(
        (failure) {
          logger.i("===== ERROR: ${failure.message} =====");
          state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
            isSuccess: false,
          );
        },
        (userData) {
          logger.i("===== SUCCESS: User authenticated =====");
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

      return account;
    } on GoogleSignInException catch (e) {
      // Handle specific Google Sign-In exceptions
      String errorMessage = 'Google Sign In failed';

      logger.i(
        "===== GoogleSignInException: ${e.code} - ${e.description} =====",
      );

      switch (e.code) {
        case GoogleSignInExceptionCode.interrupted:
          errorMessage = 'Network error. Please check your connection.';
          break;
        case GoogleSignInExceptionCode.canceled:
          errorMessage = 'Sign in was cancelled';
          break;
        case GoogleSignInExceptionCode.userMismatch:
          errorMessage = 'Sign in failed: ${e.description ?? "Unknown error"}';
          break;
        default:
          errorMessage =
              'Google Sign In error: ${e.code.name} - ${e.description}';
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMessage,
        isSuccess: false,
      );
      return null;
    } catch (e, stackTrace) {
      // Handle other exceptions
      logger.i("===== UNEXPECTED ERROR: $e =====");
      logger.i("===== STACK TRACE: $stackTrace =====");

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unexpected error: ${e.toString()}',
        isSuccess: false,
      );
      return null;
    }
  }

  // Sign out method
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      state = state.copyWith(
        isSuccess: false,
        userData: null,
        errorMessage: null,
      );
    } catch (e) {
      print("Sign out error: $e");
    }
  }
}

// Provider
final registerNotifierProvider =
    NotifierProvider<RegisterNotifier, RegisterState>(() {
      return RegisterNotifier();
    });
