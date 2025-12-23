import 'package:dartz/dartz.dart';
import 'package:utakula_v2/core/error/exceptions.dart';
import 'package:utakula_v2/core/error/failures.dart';
import 'package:utakula_v2/features/account/data/data_sources/user_account_data_source.dart';
import 'package:utakula_v2/features/account/domain/entities/user_entity.dart';
import 'package:utakula_v2/features/account/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserAccountDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> getUserAccountDetails() async {
    try {
      final result = await remoteDataSource.getUserAccountDetails();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserAccountDetails(
    UserEntity userEntity,
  ) async {
    try {
      final result = await remoteDataSource.updateUserAccountDetails(
        userEntity,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }
}
