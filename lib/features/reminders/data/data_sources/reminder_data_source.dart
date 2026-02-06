import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/common/helpers/helper_utils.dart';
import 'package:utakula_v2/core/error/exceptions.dart';
import 'package:utakula_v2/core/network/api_endpoints.dart';
import 'package:utakula_v2/core/network/dio_client.dart';
import 'package:utakula_v2/core/network/exception_handler.dart';
import 'package:utakula_v2/features/reminders/data/models/notification_model.dart';
import 'package:utakula_v2/features/reminders/data/models/reminder_model.dart';
import 'package:utakula_v2/features/reminders/domain/entities/notification_entity.dart';
import 'package:utakula_v2/features/reminders/domain/entities/reminder_entity.dart';

abstract class ReminderDataSource {
  Future<ReminderEntity> getUserNotificationSettings();

  Future<void> saveUserNotificationSettings(ReminderEntity reminderEntity);

  Future<void> sendUserNotification(NotificationEntity notificationEntity);
}

class ReminderDataSourceImpl implements ReminderDataSource {
  final DioClient dioClient;
  ExceptionHandler exceptionHandler = ExceptionHandler();

  ReminderDataSourceImpl(this.dioClient, this.exceptionHandler);

  Logger logger = Logger();

  @override
  Future<ReminderEntity> getUserNotificationSettings() async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.getUserNotificationSettings,
      );

      final payload = response.data['payload'];

      return ReminderModel.fromJson(payload).toEntity();
    } on DioException catch (e) {
      throw exceptionHandler.handleException(e);
    } catch (e) {
      throw ServerException("Unexpected error: $e");
    }
  }

  @override
  Future<void> saveUserNotificationSettings(
    ReminderEntity reminderEntity,
  ) async {
    try {
      final reminderModel = ReminderModel.fromEntity(reminderEntity);

      final response = await dioClient.post(
        ApiEndpoints.saveUserNotificationSettings,
        data: reminderModel.toJson(),
      );
    } on DioException catch (e) {
      throw exceptionHandler.handleException(e);
    } catch (e) {
      throw ServerException("Unexpected error: $e");
    }
  }

  @override
  Future<void> sendUserNotification(
    NotificationEntity notificationEntity,
  ) async {
    try {
      final notificationModel = NotificationModel.fromEntity(
        notificationEntity,
      );

      final response = await dioClient.post(
        ApiEndpoints.sendUserNotification,
        data: notificationModel.toJson(),
      );
    } on DioException catch (e) {
      throw exceptionHandler.handleException(e);
    } catch (e) {
      throw ServerException("Unexpected error: $e");
    }
  }
}
