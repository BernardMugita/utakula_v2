import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/core/providers/session_provider/session_state_provider.dart';
import 'package:utakula_v2/features/register/presentation/providers/sign_up_provider.dart';
import 'package:utakula_v2/routing/routes.dart';
import 'package:gap/gap.dart';

class UtakulaLogoutPopup extends HookConsumerWidget {
  final BuildContext dialogContext;
  final Future<void> Function() onPop;
  final ValueNotifier<bool> loggingOut;

  UtakulaLogoutPopup({
    super.key,
    required this.dialogContext,
    required this.onPop,
    required this.loggingOut,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> handleLogout() async {
      loggingOut.value = true;
      await ref.read(sessionStateProvider.notifier).logout();

      await ref.read(registerStateProvider.notifier).signOut();

      await Future.delayed(const Duration(seconds: 2));

      if (context.mounted) {
        Navigator.popAndPushNamed(context, Routes.login);
      }
      loggingOut.value = false;
    }

    return AlertDialog(
      backgroundColor: ThemeUtils.secondaryColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(
            loggingOut.value
                ? FluentIcons.arrow_sync_circle_24_regular
                : FluentIcons.warning_24_regular,
            color: loggingOut.value
                ? ThemeUtils.primaryColor(context)
                : ThemeUtils.$error,
          ),
          const Gap(12),
          Expanded(
            child: Text(
              loggingOut.value ? 'Logging out...' : 'Confirm Logout',
              style: TextStyle(
                color: ThemeUtils.primaryColor(context),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: loggingOut.value
          ? const SizedBox(
              height: 60,
              child: Center(child: CircularProgressIndicator()),
            )
          : const Text(
              'Are you sure you want to log out of Utakula?',
              style: TextStyle(fontSize: 16),
            ),
      actions: loggingOut.value
          ? null
          : [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await handleLogout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeUtils.$error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
    );
  }
}
