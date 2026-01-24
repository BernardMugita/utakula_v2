import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/core/error/exceptions.dart';
import 'package:utakula_v2/core/network/api_endpoints.dart';
import 'package:utakula_v2/core/network/dio_client.dart';
import 'package:utakula_v2/core/network/exception_handler.dart';
import 'package:utakula_v2/features/account/data/models/user_metrics_model.dart';
import 'package:utakula_v2/features/account/domain/entities/user_metrics_entity.dart';

abstract class UserMetricsDataSource {
  Future<UserMetricsEntity> createUserMetrics(UserMetricsEntity userMetricsEntity);

  Future<UserMetricsEntity> getUserMetrics();

  Future<UserMetricsEntity> updateUserMetrics(
    UserMetricsEntity userMetricsEntity,
  );
}

class UserMetricsDataSourceImpl implements UserMetricsDataSource {
  final DioClient dioClient;
  Logger logger = Logger();
  ExceptionHandler exceptionHandler = ExceptionHandler();

  UserMetricsDataSourceImpl(this.dioClient, this.exceptionHandler);

  // - ---------------------------------------------------------
  // CREATE USER METRICS
  // - ---------------------------------------------------------
  @override
  Future<UserMetricsEntity> createUserMetrics(
    UserMetricsEntity userMetricsEntity,
  ) async {
    try {
      final userMetricsModel = UserMetricsModel.fromEntity(userMetricsEntity);
      final response = await dioClient.post(
        ApiEndpoints.createMetrics,
        data: userMetricsModel.toJson(),
      );
      final payload = response.data['payload'];

      return UserMetricsModel.fromJson(payload).toEntity();
    } on DioException catch (e) {
      throw exceptionHandler.handleException(e);
    } catch (e) {
      throw ServerException("Unexpected error: $e");
    }
  }

  // - ---------------------------------------------------------
  // GET USER ACCOUNT DETAILS
  // - ---------------------------------------------------------
  @override
  Future<UserMetricsEntity> getUserMetrics() async {
    try {
      final response = await dioClient.post(ApiEndpoints.getUserMetrics);
      final payload = response.data['payload'];

      return UserMetricsModel.fromJson(payload).toEntity();
    } on DioException catch (e) {
      throw exceptionHandler.handleException(e);
    } catch (e) {
      throw ServerException("Unexpected error: $e");
    }
  }

  // - ---------------------------------------------------------
  // UPDATE USER ACCOUNT DETAILS
  // - ---------------------------------------------------------
  @override
  Future<UserMetricsEntity> updateUserMetrics(
    UserMetricsEntity userMetricsEntity,
  ) async {
    try {
      final userMetricsModel = UserMetricsModel.fromEntity(userMetricsEntity);

      final response = await dioClient.post(
        ApiEndpoints.updateMetrics,
        data: userMetricsModel.toJson(),
      );

      final payload = response.data['payload'];

      return UserMetricsModel.fromJson(payload).toEntity();
    } on DioException catch (e) {
      throw exceptionHandler.handleException(e);
    } catch (e) {
      throw ServerException("Unexpected error: $e");
    }
  }
}
