import 'package:go_router/go_router.dart';
import 'package:utakula_v2/core/providers/session_provider/session_state_provider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/routing/routes.dart';

class UtakulaSideNavigation extends HookConsumerWidget {
  const UtakulaSideNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggingOut = useState(false);
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    useEffect(() {
      animationController.forward();
      return null;
    }, []);

    Future<void> handleLogout() async {
      loggingOut.value = true;
      await ref.read(sessionStateProvider.notifier).logout();

      await Future.delayed(const Duration(seconds: 2));

      if (context.mounted) {
        Navigator.popAndPushNamed(context, Routes.login);
      }
      loggingOut.value = false;
    }

    void showLogoutDialog() {
      showDialog(
        context: context,
        barrierDismissible: !loggingOut.value,
        builder: (BuildContext dialogContext) {
          return HookConsumer(
            builder: (context, ref, child) {
              return AlertDialog(
                backgroundColor: ThemeUtils.$secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    Icon(
                      loggingOut.value
                          ? FluentIcons.arrow_sync_circle_24_regular
                          : FluentIcons.warning_24_regular,
                      color: loggingOut.value
                          ? ThemeUtils.$primaryColor
                          : ThemeUtils.$error,
                    ),
                    const Gap(12),
                    Expanded(
                      child: Text(
                        loggingOut.value ? 'Logging out...' : 'Confirm Logout',
                        style: TextStyle(
                          color: ThemeUtils.$primaryColor,
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
            },
          );
        },
      );
    }

    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 50),
      color: Colors.transparent,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: animationController,
                curve: Curves.easeOutCubic,
              ),
            ),
        child: Container(
          width: MediaQuery.of(context).size.width / 1.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: ThemeUtils.$secondaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ThemeUtils.$primaryColor.withOpacity(0.1),
                      ThemeUtils.$secondaryColor,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ThemeUtils.$primaryColor,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: ThemeUtils.$primaryColor.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: ThemeUtils.$backgroundColor,
                        child: const Icon(
                          FluentIcons.person_24_filled,
                          size: 50,
                          color: ThemeUtils.$primaryColor,
                        ),
                      ),
                    ),
                    const Gap(16),
                    const Text(
                      'Utakula',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ThemeUtils.$primaryColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      'Meal Planning Made Easy',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: ListView(
                    children: [
                      _buildNavigationItem(
                        context: context,
                        title: 'Home',
                        route: Routes.home,
                        icon: FluentIcons.home_24_filled,
                      ),
                      _buildNavigationItem(
                        context: context,
                        title: 'New Meal Plan',
                        route: Routes.newPlan,
                        icon: FluentIcons.table_add_24_filled,
                      ),
                      const Gap(8),
                      _buildNavigationItem(
                        context: context,
                        title: 'Foods',
                        route: Routes.foods,
                        icon: FluentIcons.food_24_filled,
                      ),
                      const Gap(8),
                      _buildNavigationItem(
                        context: context,
                        title: 'Recipes',
                        route: Routes.recipes,
                        icon: FluentIcons.bowl_salad_24_filled,
                      ),
                      const Gap(8),
                      _buildNavigationItem(
                        context: context,
                        title: 'Reminders',
                        route: Routes.reminders,
                        icon: FluentIcons.clock_24_filled,
                      ),
                      const Gap(20),
                      const Divider(),
                      const Gap(12),
                      _buildNavigationItem(
                        context: context,
                        title: 'Account',
                        route: Routes.account,
                        icon: FluentIcons.person_accounts_24_filled,
                      ),
                      const Gap(8),
                      _buildNavigationItem(
                        context: context,
                        title: 'Settings',
                        route: Routes.settings,
                        icon: FluentIcons.settings_24_filled,
                      ),
                    ],
                  ),
                ),
              ),

              // Logout Button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: loggingOut.value ? null : showLogoutDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeUtils.$primaryColor,
                    foregroundColor: ThemeUtils.$secondaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    shadowColor: ThemeUtils.$primaryColor.withOpacity(0.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(FluentIcons.arrow_exit_20_filled, size: 20),
                      const Gap(12),
                      Text(
                        loggingOut.value ? "Logging out..." : "Logout",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required BuildContext context,
    required String title,
    required String route,
    required IconData icon,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.go(route);
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(icon, color: ThemeUtils.$primaryColor, size: 24),
              const Gap(16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Icon(
                FluentIcons.chevron_right_24_regular,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
