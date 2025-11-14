import 'package:dartz/dartz.dart';
import 'package:utakula_v2/core/error/exceptions.dart';
import 'package:utakula_v2/core/error/failures.dart';
import 'package:utakula_v2/features/register/data/data_sources/sign_up_data_source.dart';
import 'package:utakula_v2/features/register/domain/entities/new_user.dart';
import 'package:utakula_v2/features/register/domain/repositories/sign_up_repository.dart';

class SignUpRepositoryImpl implements SignUpRepository {
  final SignUpRemoteDataSource remoteDataSource;

  SignUpRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> registerUser(
    NewUserEntity userEntity,
  ) async {
    try {
      final result = await remoteDataSource.registerUser(userEntity);
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
