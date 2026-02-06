import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/core/services/notifications/local_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:utakula_v2/features/account/domain/entities/user_entity.dart';
import 'package:utakula_v2/features/account/presentation/providers/user_providers.dart';
import 'package:flutter_timezone/flutter_timezone.dart' as ftz;

class FirebaseMessagingService {
  // Private constructor for singleton pattern
  FirebaseMessagingService._internal();

  // singleton instance
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();

  // factory constructor
  factory FirebaseMessagingService.instance() => _instance;

  // Local notifications handler
  LocalNotificationService? _localNotificationService;

  // Logger
  Logger logger = Logger();

  // Initialize local notifications
  Future<void> init({
    required LocalNotificationService localNotificationService,
    required WidgetRef ref,
  }) async {
    _localNotificationService = LocalNotificationService();

    // handle push notification token
    _handlePushNotificationToken(ref);

    // request notification permission
    _requestPermission();

    // register background services
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // listen for messages on foreground
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // listen for messages on background
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Check for initial message
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }
  }

  // Handle push notification token
  Future<void> _handlePushNotificationToken(WidgetRef ref) async {
    final token = await FirebaseMessaging.instance.getToken();
    logger.i("Device token: $token");

    final userNotifier = ref.read(userStateProvider.notifier);

    // Send initial token to server immediately
    if (token != null) {
      logger.i("Sending initial device token to server");
      final userEntity = UserEntity(deviceToken: token);
      await userNotifier.updateUserAccountDetails(userEntity);
    }

    // Listen for token refresh (when token changes in the future)
    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) async {
          logger.i("New device token: $fcmToken");

          final userEntity = UserEntity(
            deviceToken: fcmToken,
          ); // Use fcmToken, not token
          logger.i("Sending refreshed token: ${userEntity.deviceToken}");

          // Send token to server
          await userNotifier.updateUserAccountDetails(userEntity);
        })
        .onError((error) {
          logger.e("Error getting token: $error");
        });
  }

  Future<void> _requestPermission() async {
    final result = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (result.authorizationStatus == AuthorizationStatus.authorized) {
      logger.i("Permission granted");
    } else if (result.authorizationStatus == AuthorizationStatus.denied) {
      logger.e("Permission denied");
    }
  }

  void _onForegroundMessage(RemoteMessage message) async {
    logger.i("Message received: ${message.data}");

    final notification = message.notification;

    if (notification != null) {
      _localNotificationService?.showNotification(
        notification.title,
        notification.body,
        message.data.toString(),
      );
    }
  }

  //
  void _onMessageOpenedApp(RemoteMessage message) async {
    logger.i("Message opened app: ${message.data.toString()}");
  }

  @pragma('vm:entry-point')
  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    logger.i("Background message received: ${message.data}");
  }
}
