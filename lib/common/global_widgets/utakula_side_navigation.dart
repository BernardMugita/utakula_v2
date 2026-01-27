import 'package:go_router/go_router.dart';
import 'package:utakula_v2/common/global_widgets/utakula_logout_popup.dart';
import 'package:utakula_v2/common/global_widgets/utakula_theme_toggler.dart';
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

    void showLogoutDialog(ValueNotifier<bool> loggingOut) {
      showDialog(
        context: context,
        barrierDismissible: !loggingOut.value,
        builder: (BuildContext dialogContext) {
          return UtakulaLogoutPopup(
            loggingOut: loggingOut,
            dialogContext: dialogContext,
            onPop: () async {
              // This can be used for additional cleanup if needed
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
            color: ThemeUtils.secondaryColor(context),
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
                      ThemeUtils.primaryColor(context).withOpacity(0.1),
                      ThemeUtils.secondaryColor(context),
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
                          color: ThemeUtils.primaryColor(context),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: ThemeUtils.primaryColor(
                              context,
                            ).withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: ThemeUtils.backgroundColor(context),
                        child: Image(
                          height: 50,
                          width: 50,
                          fit: BoxFit.contain,
                          image: AssetImage(
                            "assets/images/utakula-logo-green.png",
                          ),
                        ),
                      ),
                    ),
                    const Gap(16),
                    Text(
                      'Utakula',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ThemeUtils.primaryColor(context),
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
                    const Gap(8),
                    const UtakulaThemeToggler(showLabel: true),
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
                        isComingSoon: false,
                      ),
                      const Gap(8),
                      _buildNavigationItem(
                        context: context,
                        title: 'Foods',
                        route: Routes.foods,
                        icon: FluentIcons.food_24_filled,
                        isComingSoon: false,
                      ),
                      const Gap(8),
                      _buildNavigationItem(
                        context: context,
                        title: 'Recipes',
                        route: Routes.recipes,
                        icon: FluentIcons.bowl_salad_24_filled,
                        isComingSoon: true,
                      ),
                      const Gap(8),
                      _buildNavigationItem(
                        context: context,
                        title: 'Reminders',
                        route: Routes.reminders,
                        icon: FluentIcons.clock_24_filled,
                        isComingSoon: false,
                      ),
                      const Gap(20),
                      Divider(color: ThemeUtils.blacks(context).withOpacity(0.1)),
                      const Gap(12),
                      _buildNavigationItem(
                        context: context,
                        title: 'Account',
                        route: Routes.account,
                        icon: FluentIcons.person_accounts_24_filled,
                        isComingSoon: false,
                      ),
                      const Gap(8),
                      _buildNavigationItem(
                        context: context,
                        title: 'Settings',
                        route: Routes.settings,
                        icon: FluentIcons.settings_24_filled,
                        isComingSoon: false,
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
                  onPressed: loggingOut.value
                      ? null
                      : () => showLogoutDialog(loggingOut),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeUtils.primaryColor(context),
                    foregroundColor: ThemeUtils.secondaryColor(context),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    shadowColor: ThemeUtils.primaryColor(
                      context,
                    ).withOpacity(0.5),
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
    required bool isComingSoon,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isComingSoon
            ? null
            : () {
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
              Icon(icon, color: ThemeUtils.primaryColor(context), size: 24),
              const Gap(16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ThemeUtils.blacks(context),
                  ),
                ),
              ),
              if (isComingSoon ?? false) ...[
                const Gap(8),
                Material(
                  color: ThemeUtils.$info.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      "Coming Soon",
                      style: TextStyle(color: ThemeUtils.$info, fontSize: 12),
                    ),
                  ),
                ),
              ] else ...const [Gap(8)],
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
