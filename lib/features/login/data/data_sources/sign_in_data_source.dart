import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/auth_user.dart';
import '../models/auth_user_model.dart';

abstract class SignInRemoteDataSource {
  Future<Map<String, dynamic>> authorizeUser(AuthUserEntity userEntity);
}

class SignInRemoteDataSourceImpl implements SignInRemoteDataSource {
  final DioClient dioClient;
  Logger logger = Logger();

  SignInRemoteDataSourceImpl(this.dioClient);

  @override
  Future<Map<String, dynamic>> authorizeUser(AuthUserEntity userEntity) async {
    try {
      final authUserModel = AuthUserModel.fromEntity(userEntity);

      final response = await dioClient.post(
        ApiEndpoints.signIn,
        data: authUserModel.toJson(),
      );

      if (response.data is List && (response.data as List).isNotEmpty) {
        return (response.data as List).first as Map<String, dynamic>;
      } else if (response.data is Map) {
        return response.data as Map<String, dynamic>;
      } else {
        logger.e('Invalid response format: $response');
        throw ServerException('Invalid response format');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        logger.e('Server error: ${e.response?.data}');
        throw ServerException(
          e.response?.data['message'] ?? e.message ?? 'Server error',
        );
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        logger.e('Connection timeout: ${e.message}');
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        logger.e('No internet connection: ${e.message}');
        throw NetworkException('No internet connection');
      } else {
        logger.e('Unknown error: ${e.message}');
        throw ServerException(e.message ?? 'Unknown error occurred');
      }
    } catch (e) {
      logger.e('Unexpected error: $e');
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }
}
