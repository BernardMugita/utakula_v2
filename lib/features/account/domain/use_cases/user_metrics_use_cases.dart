import 'package:dartz/dartz.dart';
import 'package:utakula_v2/core/error/failures.dart';
import 'package:utakula_v2/features/account/domain/entities/user_metrics_entity.dart';
import 'package:utakula_v2/features/account/domain/repositories/user_metrics_repository.dart';

class CreateUserMetrics {
  final UserMetricsRepository repository;

  CreateUserMetrics(this.repository);

  Future<Either<Failure, UserMetricsEntity>> call(
    UserMetricsEntity userMetricsEntity,
  ) async {
    return await repository.createUserMetrics(userMetricsEntity);
  }
}

class GetUserMetrics {
  final UserMetricsRepository repository;

  GetUserMetrics(this.repository);

  Future<Either<Failure, UserMetricsEntity>> call() async {
    return await repository.getUserMetrics();
  }
}

class UpdateUserMetrics {
  final UserMetricsRepository repository;

  UpdateUserMetrics(this.repository);

  Future<Either<Failure, UserMetricsEntity>> call(
    UserMetricsEntity userMetricsEntity,
  ) async {
    return await repository.updateUserMetrics(userMetricsEntity);
  }
}
