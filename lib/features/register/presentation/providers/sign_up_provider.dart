import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utakula_v2/core/network/api_endpoints.dart';
import 'package:utakula_v2/core/network/dio_client.dart';
import 'package:utakula_v2/features/register/data/data_sources/sign_up_data_source.dart';
import 'package:utakula_v2/features/register/data/repositories/sign_up_user_impl.dart';
import 'package:utakula_v2/features/register/domain/repositories/sign_up_repository.dart';
import 'package:utakula_v2/features/register/domain/usecases/register_user_usecase.dart';
import 'package:utakula_v2/features/register/presentation/providers/sign_up_state_provider.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(
    baseUrl: ApiEndpoints.productionURL
  );
});

final signUpRemoteDataSourceProvider = Provider<SignUpRemoteDataSource>((ref) {
  return SignUpRemoteDataSourceImpl(ref.read(dioClientProvider));
});

final signUpRepositoryProvider = Provider<SignUpRepository>((ref) {
  return SignUpRepositoryImpl(ref.read(signUpRemoteDataSourceProvider));
});

final registerUserUseCaseProvider = Provider<RegisterUserUseCase>((ref) {
  return RegisterUserUseCase(ref.read(signUpRepositoryProvider));
});

final signUpWithGoogleProvider = Provider<SignUpWithGoogle>((ref) {
  return SignUpWithGoogle(ref.read(signUpRepositoryProvider));
});

final registerStateProvider = NotifierProvider<RegisterNotifier, RegisterState>(
  () {
    return RegisterNotifier();
  },
);
