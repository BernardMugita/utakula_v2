import 'package:dartz/dartz.dart';
import 'package:utakula_v2/core/error/failures.dart';
import 'package:utakula_v2/features/reminders/domain/entities/notification_entity.dart';
import 'package:utakula_v2/features/reminders/domain/entities/reminder_entity.dart';

abstract class ReminderRepository {
  Future<Either<Failure, ReminderEntity>> getUserNotificationSettings();

  Future<Either<Failure, void>> saveUserNotificationSettings(
    ReminderEntity reminderEntity,
  );

  Future<Either<Failure, void>> sendUserNotification(
    NotificationEntity notificationEntity,
  );
}
