import 'package:dartz/dartz.dart';
import 'package:utakula_v2/core/error/failures.dart';
import 'package:utakula_v2/features/account/domain/entities/user_entity.dart';
import 'package:utakula_v2/features/account/domain/entities/user_metrics_entity.dart';

abstract class UserMetricsRepository {
  Future<Either<Failure, UserMetricsEntity>> createUserMetrics(
    UserMetricsEntity userMetricsEntity,
  );

  Future<Either<Failure, UserMetricsEntity>> getUserMetrics();

  Future<Either<Failure, UserMetricsEntity>> updateUserMetrics(
    UserMetricsEntity userMetricsEntity,
  );
}
