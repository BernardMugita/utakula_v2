import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/core/network/api_endpoints.dart';
import 'package:utakula_v2/core/network/dio_client.dart';
import 'package:utakula_v2/core/network/exception_handler.dart';
import 'package:utakula_v2/features/reminders/data/data_sources/reminder_data_source.dart';
import 'package:utakula_v2/features/reminders/data/repository/reminder_repository_impl.dart';
import 'package:utakula_v2/features/reminders/domain/entities/reminder_entity.dart';
import 'package:utakula_v2/features/reminders/domain/repository/reminder_repository.dart';
import 'package:utakula_v2/features/reminders/domain/use_cases/reminder_use_cases.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(
    baseUrl: ApiEndpoints.productionURL
  );
});

final ExceptionHandler exceptionHandler = ExceptionHandler();

final reminderRemoteDataSourceProvider = Provider<ReminderDataSource>((ref) {
  return ReminderDataSourceImpl(ref.read(dioClientProvider), exceptionHandler);
});

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return ReminderRepositoryImpl(ref.read(reminderRemoteDataSourceProvider));
});

final getUserNotificationSettingsProvider =
    Provider<GetUserNotificationSettings>((ref) {
      return GetUserNotificationSettings(ref.read(reminderRepositoryProvider));
    });

final saveUserNotificationSettingsProvider =
    Provider<SaveUserNotificationSettings>((ref) {
      return SaveUserNotificationSettings(ref.read(reminderRepositoryProvider));
    });

class ReminderState {
  final bool isLoading;
  final bool isSubmitting;
  final ReminderEntity? reminder;
  final String? errorMessage;

  const ReminderState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.reminder,
    this.errorMessage,
  });

  ReminderState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    ReminderEntity? reminder,
    String? errorMessage,
  }) {
    return ReminderState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      reminder: reminder,
      errorMessage: errorMessage,
    );
  }
}

class ReminderNotifier extends Notifier<ReminderState> {
  @override
  ReminderState build() {
    return const ReminderState();
  }

  Logger logger = Logger();

  Future<void> getUserNotificationSettings() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final getUserNotificationSettings = ref.read(
      getUserNotificationSettingsProvider,
    );
    final result = await getUserNotificationSettings();

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (reminder) {
        state = state.copyWith(isLoading: false, reminder: reminder);
      },
    );
  }

  Future<void> saveUserNotificationSettings(
    ReminderEntity reminderEntity,
  ) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    final saveUserNotificationSettings = ref.read(
      saveUserNotificationSettingsProvider,
    );
    final result = await saveUserNotificationSettings(reminderEntity);
    result.fold(
      (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        );
      },
      (reminder) {
        state = state.copyWith(isSubmitting: false);
      },
    );
  }
}

final reminderStateProvider = NotifierProvider<ReminderNotifier, ReminderState>(
  () {
    return ReminderNotifier();
  },
);
