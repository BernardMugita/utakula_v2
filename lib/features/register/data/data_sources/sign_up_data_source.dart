import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/core/error/exceptions.dart';
import 'package:utakula_v2/core/network/api_endpoints.dart';
import 'package:utakula_v2/core/network/dio_client.dart';
import 'package:utakula_v2/features/register/data/models/google_sign_up_model.dart';
import 'package:utakula_v2/features/register/data/models/new_user_model.dart';
import 'package:utakula_v2/features/register/domain/entities/google_user_entity.dart';
import 'package:utakula_v2/features/register/domain/entities/new_user.dart';

abstract class SignUpRemoteDataSource {
  Future<Map<String, dynamic>> registerUser(NewUserEntity userEntity);

  Future<Map<String, dynamic>> signUpWithGoogle(GoogleUserEntity userEntity);
}

class SignUpRemoteDataSourceImpl implements SignUpRemoteDataSource {
  final DioClient dioClient;
  Logger logger = Logger();

  SignUpRemoteDataSourceImpl(this.dioClient);

  @override
  Future<Map<String, dynamic>> registerUser(NewUserEntity userEntity) async {
    try {
      final newUserModel = NewUserModel.fromEntity(userEntity);

      final response = await dioClient.post(
        ApiEndpoints.signUp,
        data: newUserModel.toJson(),
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

  @override
  Future<Map<String, dynamic>> signUpWithGoogle(GoogleUserEntity userEntity) async {
    try {
      final googleUserModel = GoogleSignUpModel.fromEntity(userEntity);

      final response = await dioClient.post(
        ApiEndpoints.googleAuth,
        data: googleUserModel.toJson(),
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
