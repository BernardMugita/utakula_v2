import 'package:dartz/dartz.dart';
import 'package:utakula_v2/core/error/exceptions.dart';
import 'package:utakula_v2/core/error/failures.dart';
import 'package:utakula_v2/features/account/data/data_sources/user_account_data_source.dart';
import 'package:utakula_v2/features/account/data/data_sources/user_metrics_data_source.dart';
import 'package:utakula_v2/features/account/domain/entities/user_entity.dart';
import 'package:utakula_v2/features/account/domain/entities/user_metrics_entity.dart';
import 'package:utakula_v2/features/account/domain/repositories/user_metrics_repository.dart';
import 'package:utakula_v2/features/account/domain/repositories/user_repository.dart';

class UserMetricsRepositoryImpl implements UserMetricsRepository {
  final UserMetricsDataSource remoteDataSource;

  UserMetricsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserMetricsEntity>> createUserMetrics(
    UserMetricsEntity userMetricsEntity,
  ) async {
    try {
      final result = await remoteDataSource.createUserMetrics(
        userMetricsEntity,
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

  @override
  Future<Either<Failure, UserMetricsEntity>> getUserMetrics() async {
    try {
      final result = await remoteDataSource.getUserMetrics();
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
  Future<Either<Failure, UserMetricsEntity>> updateUserMetrics(
    UserMetricsEntity userMetricsEntity,
  ) async {
    try {
      final result = await remoteDataSource.updateUserMetrics(
        userMetricsEntity,
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
