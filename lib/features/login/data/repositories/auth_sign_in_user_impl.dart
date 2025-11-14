import 'package:dartz/dartz.dart';
import 'package:utakula_v2/features/login/data/data_sources/sign_in_data_source.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_sign_in_repository.dart';

class AuthSignInRepositoryImpl implements AuthSignInRepository {
  final SignInRemoteDataSource remoteDataSource;

  AuthSignInRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> authorizeUser(
    AuthUserEntity userEntity,
  ) async {
    try {
      final result = await remoteDataSource.authorizeUser(userEntity);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
