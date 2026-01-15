import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utakula_v2/common/global_widgets/utakula_exit_alert.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/core/services/firebase_messaging_service.dart';
import 'package:utakula_v2/core/services/local_notification_service.dart';
import 'package:utakula_v2/firebase_options.dart';
import 'package:utakula_v2/l10n/app_localization.dart';
import 'package:utakula_v2/routing/router_provider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localization/flutter_localization.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:utakula_v2/l10n/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize local notifications here (doesn't need ref)
  final localNotificationService = LocalNotificationService();
  await localNotificationService.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    // Initialize Firebase Messaging with ref
    useEffect(() {
      final localNotificationService = LocalNotificationService();
      final firebaseMessagingService = FirebaseMessagingService.instance();

      firebaseMessagingService.init(
        localNotificationService: localNotificationService,
        ref: ref,
      );

      return null;
    }, []); // Empty dependency array means run once on mount

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => _showExitConfirmationDialog(context, (pop) {}),
      child: MaterialApp.router(
        title: 'Utakula_V2',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: ThemeUtils.$primaryColor,
          ),
          fontFamily: 'Poppins',
        ),
        supportedLocales: L10n.all,
        locale: const Locale('en'),
        localizationsDelegates: const [AppLocalizations.delegate],
        routerConfig: router,
      ),
    );
  }

  Future<void> _showExitConfirmationDialog(
    BuildContext context,
    void Function(bool) onPop,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return UtakulaExitAlert(
          dialogContext: dialogContext,
          onPop: onPop,
        );
      },
    );
  }
}
