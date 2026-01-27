import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/common/global_widgets/utakula_exit_alert.dart';
import 'package:utakula_v2/common/global_widgets/utakula_side_navigation.dart';
import 'package:utakula_v2/common/helpers/helper_utils.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/core/providers/theme_provider/theme_provider.dart';

class Settings extends HookConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = Logger();
    final helperUtils = HelperUtils();

    // State management for settings
    final themeNotifier = ref.read(themeProvider.notifier);
    final isDarkMode = themeNotifier.isDarkMode(context);
    final notificationsEnabled = useState(true);
    final isSaving = useState(false);

    // Load settings on mount
    useEffect(() {
      Future.microtask(() async {
        // TODO: Load saved settings from storage/API
        logger.i('Loading user settings...');
        // Example:
        // final savedSettings = await loadSettings();
        // isDarkMode.value = savedSettings.isDarkMode;
        // notificationsEnabled.value = savedSettings.notificationsEnabled;
      });
      return null;
    }, []);

    // Save settings
    Future<void> saveSettings() async {
      isSaving.value = true;

      try {
        await Future.delayed(const Duration(milliseconds: 500));

        if (context.mounted) {
          helperUtils.showSnackBar(
            context,
            'Settings saved successfully!',
            ThemeUtils.$success,
          );
        }
      } catch (e) {
        logger.e('Error saving settings: $e');
        if (context.mounted) {
          helperUtils.showSnackBar(
            context,
            'Failed to save settings',
            ThemeUtils.$error,
          );
        }
      } finally {
        isSaving.value = false;
      }
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => _showExitConfirmationDialog(context, (pop) {}),
      child: Scaffold(
        backgroundColor: ThemeUtils.backgroundColor(context),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Icon(
                Icons.reorder,
                color: ThemeUtils.primaryColor(context),
              ),
            ),
          ),
          title: Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ThemeUtils.primaryColor(context),
            ),
          ),
        ),
        drawer: UtakulaSideNavigation(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ThemeUtils.primaryColor(context),
                      ThemeUtils.primaryColor(context).withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeUtils.primaryColor(context).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ThemeUtils.secondaryColor(
                          context,
                        ).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        FluentIcons.settings_24_filled,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Preferences',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Gap(4),
                          Text(
                            'Customize your app experience',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(32),

              // Appearance Section
              Text(
                'Appearance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ThemeUtils.primaryColor(context),
                ),
              ),
              const Gap(12),
              // Dark Mode Toggle Card
              _buildSettingCard(
                context: context,
                icon: isDarkMode
                    ? FluentIcons.weather_moon_24_filled
                    : FluentIcons.weather_sunny_24_filled,
                title: 'Dark Mode',
                subtitle: isDarkMode
                    ? 'Dark theme enabled'
                    : 'Light theme enabled',
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (value) async {
                    await themeNotifier.toggleTheme();
                    if (context.mounted) {
                      helperUtils.showSnackBar(
                        context,
                        isDarkMode ? 'Light mode enabled' : 'Dark mode enabled',
                        ThemeUtils.$success,
                      );
                    }
                  },
                  activeColor: ThemeUtils.primaryColor(context),
                  activeTrackColor: ThemeUtils.primaryColor(
                    context,
                  ).withOpacity(0.3),
                ),
                onTap: () async {
                  await themeNotifier.toggleTheme();
                  if (context.mounted) {
                    helperUtils.showSnackBar(
                      context,
                      isDarkMode ? 'Light mode enabled' : 'Dark mode enabled',
                      ThemeUtils.$success,
                    );
                  }
                },
              ),
              const Gap(32),
              // Notifications Section
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ThemeUtils.primaryColor(context),
                ),
              ),
              const Gap(12),

              // Notifications Toggle Card
              _buildSettingCard(
                context: context,
                icon: FluentIcons.alert_24_regular,
                title: 'Push Notifications',
                subtitle: notificationsEnabled.value
                    ? 'Notifications enabled'
                    : 'Notifications disabled',
                trailing: Switch(
                  value: notificationsEnabled.value,
                  onChanged: (value) {
                    notificationsEnabled.value = value;
                    saveSettings();
                  },
                  activeColor: ThemeUtils.primaryColor(context),
                  activeTrackColor: ThemeUtils.primaryColor(
                    context,
                  ).withOpacity(0.3),
                ),
                onTap: () {
                  notificationsEnabled.value = !notificationsEnabled.value;
                  saveSettings();
                },
              ),

              const Gap(32),

              // Additional Settings Section (Placeholder)
              Text(
                'More Settings',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ThemeUtils.primaryColor(context),
                ),
              ),
              const Gap(12),

              // Language Setting (Placeholder)
              _buildSettingCard(
                context: context,
                icon: FluentIcons.local_language_24_regular,
                title: 'Language',
                subtitle: 'English (US)',
                trailing: Icon(
                  FluentIcons.chevron_right_24_regular,
                  color: ThemeUtils.primaryColor(context).withOpacity(0.5),
                  size: 20,
                ),
                onTap: () {
                  // TODO: Navigate to language selection
                  helperUtils.showSnackBar(
                    context,
                    'Language settings coming soon',
                    ThemeUtils.primaryColor(context),
                  );
                },
              ),

              const Gap(12),

              // Data & Storage (Placeholder)
              _buildSettingCard(
                context: context,
                icon: FluentIcons.database_24_regular,
                title: 'Data & Storage',
                subtitle: 'Manage app data',
                trailing: Icon(
                  FluentIcons.chevron_right_24_regular,
                  color: ThemeUtils.primaryColor(context).withOpacity(0.5),
                  size: 20,
                ),
                onTap: () {
                  // TODO: Navigate to data & storage settings
                  helperUtils.showSnackBar(
                    context,
                    'Data settings coming soon',
                    ThemeUtils.primaryColor(context),
                  );
                },
              ),

              const Gap(12),

              // Privacy & Security (Placeholder)
              _buildSettingCard(
                context: context,
                icon: FluentIcons.shield_24_regular,
                title: 'Privacy & Security',
                subtitle: 'Control your privacy',
                trailing: Icon(
                  FluentIcons.chevron_right_24_regular,
                  color: ThemeUtils.primaryColor(context).withOpacity(0.5),
                  size: 20,
                ),
                onTap: () {
                  // TODO: Navigate to privacy settings
                  helperUtils.showSnackBar(
                    context,
                    'Privacy settings coming soon',
                    ThemeUtils.primaryColor(context),
                  );
                },
              ),

              const Gap(32),

              // About Section
              Text(
                'About',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ThemeUtils.primaryColor(context),
                ),
              ),
              const Gap(12),

              // App Version
              _buildSettingCard(
                context: context,
                icon: FluentIcons.info_24_regular,
                title: 'App Version',
                subtitle: '1.0.0',
                trailing: null,
                onTap: null,
              ),

              const Gap(12),

              // Terms & Conditions
              _buildSettingCard(
                context: context,
                icon: FluentIcons.document_text_24_regular,
                title: 'Terms & Conditions',
                subtitle: 'View terms',
                trailing: Icon(
                  FluentIcons.chevron_right_24_regular,
                  color: ThemeUtils.primaryColor(context).withOpacity(0.5),
                  size: 20,
                ),
                onTap: () {
                  // TODO: Navigate to terms
                  helperUtils.showSnackBar(
                    context,
                    'Terms & Conditions coming soon',
                    ThemeUtils.primaryColor(context),
                  );
                },
              ),

              const Gap(12),

              // Privacy Policy
              _buildSettingCard(
                context: context,
                icon: FluentIcons.shield_checkmark_24_regular,
                title: 'Privacy Policy',
                subtitle: 'View policy',
                trailing: Icon(
                  FluentIcons.chevron_right_24_regular,
                  color: ThemeUtils.primaryColor(context).withOpacity(0.5),
                  size: 20,
                ),
                onTap: () {
                  // TODO: Navigate to privacy policy
                  helperUtils.showSnackBar(
                    context,
                    'Privacy Policy coming soon',
                    ThemeUtils.primaryColor(context),
                  );
                },
              ),

              const Gap(32),

              // Help & Support Section
              Text(
                'Help & Support',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ThemeUtils.primaryColor(context),
                ),
              ),
              const Gap(12),

              // Help Center
              _buildSettingCard(
                context: context,
                icon: FluentIcons.question_circle_24_regular,
                title: 'Help Center',
                subtitle: 'Get help and support',
                trailing: Icon(
                  FluentIcons.chevron_right_24_regular,
                  color: ThemeUtils.primaryColor(context).withOpacity(0.5),
                  size: 20,
                ),
                onTap: () {
                  // TODO: Navigate to help center
                  helperUtils.showSnackBar(
                    context,
                    'Help Center coming soon',
                    ThemeUtils.primaryColor(context),
                  );
                },
              ),

              const Gap(12),

              // Contact Us
              _buildSettingCard(
                context: context,
                icon: FluentIcons.mail_24_regular,
                title: 'Contact Us',
                subtitle: 'Send us feedback',
                trailing: Icon(
                  FluentIcons.chevron_right_24_regular,
                  color: ThemeUtils.primaryColor(context).withOpacity(0.5),
                  size: 20,
                ),
                onTap: () {
                  // TODO: Navigate to contact form or open email
                  helperUtils.showSnackBar(
                    context,
                    'Contact form coming soon',
                    ThemeUtils.primaryColor(context),
                  );
                },
              ),

              const Gap(32),

              // Danger Zone
              const Text(
                'Danger Zone',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ThemeUtils.$error,
                ),
              ),
              const Gap(12),

              // Clear Cache
              _buildSettingCard(
                context: context,
                icon: FluentIcons.broom_24_regular,
                title: 'Clear Cache',
                subtitle: 'Free up storage space',
                trailing: Icon(
                  FluentIcons.chevron_right_24_regular,
                  color: ThemeUtils.$error.withOpacity(0.5),
                  size: 20,
                ),
                onTap: () {
                  _showClearCacheDialog(context, helperUtils);
                },
                isDanger: true,
              ),

              const Gap(12),

              // Delete Account
              _buildSettingCard(
                context: context,
                icon: FluentIcons.delete_24_regular,
                title: 'Delete Account',
                subtitle: 'Permanently delete your account',
                trailing: Icon(
                  FluentIcons.chevron_right_24_regular,
                  color: ThemeUtils.$error.withOpacity(0.5),
                  size: 20,
                ),
                onTap: () {
                  _showDeleteAccountDialog(context, helperUtils);
                },
                isDanger: true,
              ),

              const Gap(32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool isDanger = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeUtils.secondaryColor(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDanger
                ? ThemeUtils.$error.withOpacity(0.2)
                : ThemeUtils.primaryColor(context).withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDanger
                    ? ThemeUtils.$error.withOpacity(0.1)
                    : ThemeUtils.primaryColor(context).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDanger
                    ? ThemeUtils.$error
                    : ThemeUtils.primaryColor(context),
                size: 24,
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDanger
                          ? ThemeUtils.$error
                          : ThemeUtils.blacks(context),
                    ),
                  ),
                  const Gap(2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDanger
                          ? ThemeUtils.$error.withOpacity(0.7)
                          : ThemeUtils.blacks(context).withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[const Gap(8), trailing],
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context, HelperUtils helperUtils) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: ThemeUtils.secondaryColor(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                FluentIcons.broom_24_regular,
                color: ThemeUtils.primaryColor(context),
              ),
              Gap(12),
              Text(
                'Clear Cache',
                style: TextStyle(
                  color: ThemeUtils.primaryColor(context),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'This will clear all cached data. Your settings and account data will not be affected.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement clear cache logic
                Navigator.of(dialogContext).pop();
                helperUtils.showSnackBar(
                  context,
                  'Cache cleared successfully',
                  ThemeUtils.$success,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeUtils.primaryColor(context),
                foregroundColor: ThemeUtils.secondaryColor(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Clear',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context, HelperUtils helperUtils) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: ThemeUtils.secondaryColor(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(FluentIcons.warning_24_filled, color: ThemeUtils.$error),
              Gap(12),
              Text(
                'Delete Account',
                style: TextStyle(
                  color: ThemeUtils.$error,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement delete account logic
                Navigator.of(dialogContext).pop();
                helperUtils.showSnackBar(
                  context,
                  'Account deletion requested',
                  ThemeUtils.$error,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeUtils.$error,
                foregroundColor: ThemeUtils.secondaryColor(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showExitConfirmationDialog(
    BuildContext context,
    void Function(bool) onPop,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return UtakulaExitAlert(dialogContext: dialogContext, onPop: onPop);
      },
    );
  }
}
