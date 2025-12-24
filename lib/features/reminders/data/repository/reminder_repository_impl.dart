import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/core/error/exceptions.dart';
import 'package:utakula_v2/core/error/failures.dart';
import 'package:utakula_v2/features/reminders/data/data_sources/reminder_data_source.dart';
import 'package:utakula_v2/features/reminders/domain/entities/reminder_entity.dart';
import 'package:utakula_v2/features/reminders/domain/repository/reminder_repository.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderDataSource reminderDataSource;

  ReminderRepositoryImpl(this.reminderDataSource);

  Logger logger = Logger();

  @override
  Future<Either<Failure, ReminderEntity>> getUserNotificationSettings() async {
    try {
      final result = await reminderDataSource.getUserNotificationSettings();
      logger.i(result);
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
  Future<Either<Failure, void>> saveUserNotificationSettings(
    ReminderEntity reminderEntity,
  ) async {
    try {
      final result = await reminderDataSource.saveUserNotificationSettings(
        reminderEntity,
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
