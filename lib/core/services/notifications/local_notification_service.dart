import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:utakula_v2/features/reminders/domain/entities/notification_entity.dart';
import 'package:utakula_v2/features/reminders/domain/entities/reminder_entity.dart';

class LocalNotificationService {
  LocalNotificationService._internal();

  static final LocalNotificationService _instance =
      LocalNotificationService._internal();

  factory LocalNotificationService() => _instance;

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  final _androidInitializationSettings = const AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  final _androidChannel = const AndroidNotificationChannel(
    'utakula_meal_reminders',
    'Meal Reminders',
    description: 'Reminders for your meals',
    importance: Importance.max,
  );

  bool _initialized = false;
  int _notificationCounter = 0;

  final Logger logger = Logger();

  /// Holds payload when app is cold-started from notification
  String? _pendingPayload;

  /// ================= INIT =================
  Future<void> init() async {
    if (_initialized) return;

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Timezone
    tz.initializeTimeZones();
    final timezoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneName.identifier));

    final settings = InitializationSettings(
      android: _androidInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);

    await requestNotificationPermissions();

    _initialized = true;
  }

  /// ================= NOTIFICATION TAP =================
  void _onNotificationResponse(NotificationResponse response) {
    if (response.payload == null) return;

    logger.i("📩 Notification tapped with payload: ${response.payload}");
    _pendingPayload = response.payload;
  }

  /// Call this AFTER app + auth + repositories are ready
  NotificationEntity? consumePendingNotification() {
    if (_pendingPayload == null) return null;

    final entity = NotificationEntity(meal: _pendingPayload!);
    _pendingPayload = null;
    return entity;
  }

  /// ================= SCHEDULING =================
  Future<void> scheduleTestNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
    String? payload,
  }) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  Future<void> showNotification(
    String? title,
    String? body,
    String? payload,
  ) async {
    await _flutterLocalNotificationsPlugin.show(
      _notificationCounter++,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: payload,
    );
  }

  /// ================= SETTINGS-BASED SCHEDULING =================
  Future<void> scheduleNotificationsFromSettings(
    ReminderEntity settings,
  ) async {
    await cancelAllNotifications();

    if (!settings.notificationsEnabled) return;

    int id = 0;

    for (final mealNotif in settings.notificationFor) {
      final meal = mealNotif.meal.toLowerCase();
      final mealTime = mealNotif.mealTime;

      for (int i = 0; i < settings.frequencyBeforeMeals; i++) {
        final now = tz.TZDateTime.now(tz.local);

        var scheduled = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          now.day,
          mealTime.hour,
          mealTime.minute,
        ).subtract(Duration(hours: settings.timeBeforeMeals - i));

        if (scheduled.isBefore(now)) {
          scheduled = scheduled.add(const Duration(days: 1));
        }

        await _flutterLocalNotificationsPlugin.zonedSchedule(
          id++,
          _title(meal, settings.timeBeforeMeals),
          'Tap to see your meal plan',
          scheduled,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: meal,
        );
      }
    }
  }

  String _title(String meal, int hours) {
    final cap = meal[0].toUpperCase() + meal.substring(1);
    return hours == 0 ? "Time for $cap!" : "$cap in $hours hours";
  }

  /// ================= PERMISSIONS =================
  Future<void> requestNotificationPermissions() async {
    final android = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();
  }

  /// ================= UTIL =================
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }
}
