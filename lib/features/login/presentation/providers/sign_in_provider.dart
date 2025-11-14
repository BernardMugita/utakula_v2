import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utakula_v2/features/login/data/data_sources/sign_in_data_source.dart';
import 'package:utakula_v2/features/login/data/repositories/auth_sign_in_user_impl.dart';
import 'package:utakula_v2/features/login/presentation/providers/sign_in_state_providers.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/auth_sign_in_repository.dart';
import '../../domain/usecases/authorize_user.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(
    baseUrl: 'https://philanthropically-farsighted-malik.ngrok-free.dev',
  );
});

final signInRemoteDataSourceProvider = Provider<SignInRemoteDataSource>((ref) {
  return SignInRemoteDataSourceImpl(ref.read(dioClientProvider));
});

final authSignInRepositoryProvider = Provider<AuthSignInRepository>((ref) {
  return AuthSignInRepositoryImpl(ref.read(signInRemoteDataSourceProvider));
});

final authorizeUserUseCaseProvider = Provider<AuthorizeUser>((ref) {
  return AuthorizeUser(ref.read(authSignInRepositoryProvider));
});

final loginStateProvider = NotifierProvider<LoginNotifier, LoginState>(() {
  return LoginNotifier();
});
