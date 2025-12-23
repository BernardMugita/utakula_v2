import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

class LocalNotificationService {
  // Private constructor for singleton pattern
  LocalNotificationService._internal();

  // singleton instance
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();

  // factory constructor
  factory LocalNotificationService() => _instance;

  // Main plugin instance for handling notifications
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  // android initialization settings using app launcher
  final _androidInitializationSettings = const AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  // android channel config
  final _androidChannel = const AndroidNotificationChannel(
    "channel_id",
    'Utakula Channel',
    description: 'Utakula notifications',
    importance: Importance.max,
  );

  // flat to track initialization status
  bool _isFlutterLocalNotificationInitialized = false;

  // counter for unique notifications
  int _notificationCounter = 0;

  // logger
  Logger logger = Logger();

  Future<void> init() async {
    if (_isFlutterLocalNotificationInitialized) {
      return;
    }

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final initializationSettings = InitializationSettings(
      android: _androidInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        logger.i(response.payload);
      },
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);

    _isFlutterLocalNotificationInitialized = true;
  }

  Future<void> showNotification(
    String? title,
    String? body,
    String? payload,
  ) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      _notificationCounter++,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
