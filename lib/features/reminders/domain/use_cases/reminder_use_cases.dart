import 'package:dartz/dartz.dart';
import 'package:utakula_v2/core/error/failures.dart';
import 'package:utakula_v2/features/reminders/domain/entities/reminder_entity.dart';
import 'package:utakula_v2/features/reminders/domain/repository/reminder_repository.dart';

class GetUserNotificationSettings {
  final ReminderRepository repository;

  GetUserNotificationSettings(this.repository);

  Future<Either<Failure, ReminderEntity>> call() async {
    return await repository.getUserNotificationSettings();
  }
}

class SaveUserNotificationSettings {
  final ReminderRepository repository;

  SaveUserNotificationSettings(this.repository);

  Future<Either<Failure, void>> call(
    ReminderEntity reminderEntity,
  ) async {
    return await repository.saveUserNotificationSettings(reminderEntity);
  }
}
