import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/core/error/exceptions.dart';
import 'package:utakula_v2/core/network/api_endpoints.dart';
import 'package:utakula_v2/core/network/dio_client.dart';
import 'package:utakula_v2/core/network/exception_handler.dart';
import 'package:utakula_v2/features/account/data/models/user_model.dart';
import 'package:utakula_v2/features/account/domain/entities/user_entity.dart';

abstract class UserAccountDataSource {
  Future<UserEntity> getUserAccountDetails();

  Future<UserEntity> updateUserAccountDetails(UserEntity userEntity);
}

class UserAccountDataSourceImpl implements UserAccountDataSource {
  final DioClient dioClient;
  Logger logger = Logger();
  ExceptionHandler exceptionHandler = ExceptionHandler();

  UserAccountDataSourceImpl(this.dioClient, this.exceptionHandler);

  // - ---------------------------------------------------------
  // GET USER ACCOUNT DETAILS
  // - ---------------------------------------------------------

  @override
  Future<UserEntity> getUserAccountDetails() async {
    try {
      final response = await dioClient.post(ApiEndpoints.getUserAccount);
      final payload = response.data['payload'];

      return UserModel.fromJson(payload).toEntity();
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
  Future<UserEntity> updateUserAccountDetails(UserEntity userEntity) async {
    try {
      final userModel = UserModel.fromEntity(userEntity);

      final response = await dioClient.post(
        ApiEndpoints.editUserAccount,
        data: userModel.toJson(),
      );

      final payload = response.data['payload'];

      return UserModel.fromJson(payload).toEntity();
    } on DioException catch (e) {
      throw exceptionHandler.handleException(e);
    } catch (e) {
      throw ServerException("Unexpected error: $e");
    }
  }
}
