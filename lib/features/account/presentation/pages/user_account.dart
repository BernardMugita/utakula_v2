import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:utakula_v2/common/global_widgets/utakula_exit_alert.dart';
import 'package:utakula_v2/common/global_widgets/utakula_side_navigation.dart';
import 'package:utakula_v2/common/helpers/helper_utils.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/account/domain/entities/user_entity.dart';
import 'package:utakula_v2/features/account/domain/entities/user_metrics_entity.dart';
import 'package:utakula_v2/features/account/presentation/providers/user_metrics_provider.dart';
import 'package:utakula_v2/features/account/presentation/providers/user_providers.dart';
import 'package:utakula_v2/features/account/presentation/widgets/edit_metrics_dialog.dart';

class UserAccount extends HookConsumerWidget {
  const UserAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = Logger();
    final helperUtils = HelperUtils();
    final userState = ref.watch(userStateProvider);
    final metricsState = ref.watch(userMetricsStateProvider);

    // State management for edit mode (account info only)
    final isEditMode = useState(false);
    final usernameController = useTextEditingController();
    final emailController = useTextEditingController();

    // Fetch user data on mount
    useEffect(() {
      Future.microtask(() {
        ref.read(userStateProvider.notifier).getUserAccountDetails();
        ref.read(userMetricsStateProvider.notifier).getUserMetrics();
      });
      return null;
    }, []);

    // Update controllers when user data loads
    useEffect(() {
      if (userState.user.username != null) {
        usernameController.text = userState.user.username ?? '';
        emailController.text = userState.user.email ?? '';
      }
      return null;
    }, [userState.user]);

    // Handle save account info
    Future<void> handleSave() async {
      final updatedUser = UserEntity(email: emailController.text);

      await ref
          .read(userStateProvider.notifier)
          .updateUserAccountDetails(updatedUser);

      if (context.mounted) {
        final state = ref.read(userStateProvider);
        if (state.errorMessage == null) {
          helperUtils.showSnackBar(
            context,
            'Account updated successfully!',
            ThemeUtils.$success,
          );
          isEditMode.value = false;
        } else {
          helperUtils.showSnackBar(
            context,
            'Failed to update account: ${state.errorMessage}',
            ThemeUtils.$error,
          );
        }
      }
    }

    // Handle edit metrics
    Future<void> handleEditMetrics() async {
      // Convert UserMetricsEntity to Map for the dialog
      Map<String, dynamic>? currentMetrics;
      if (metricsState.hasMetrics) {
        final metrics = metricsState.userMetrics!;
        currentMetrics = {
          'gender': metrics.gender,
          'age': metrics.age,
          'weight_kg': metrics.weightKG,
          'height_cm': metrics.heightCM,
          'body_fat_percentage': metrics.bodyFatPercentage,
          'activity_level': metrics.activityLevel,
          'calculated_tdee': metrics.calculatedTDEE,
          'updated_at': metrics.updatedAt,
        };
      }

      final result = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) => EditMetricsDialog(currentMetrics: currentMetrics),
      );

      if (result != null && context.mounted) {
        // Convert Map back to UserMetricsEntity
        final metricsEntity = UserMetricsEntity(
          gender: result['gender'],
          age: result['age'],
          weightKG: result['weight_kg'],
          heightCM: result['height_cm'],
          bodyFatPercentage: result['body_fat_percentage'],
          activityLevel: result['activity_level'],
          calculatedTDEE: result['calculated_tdee'],
        );

        final success = await ref
            .read(userMetricsStateProvider.notifier)
            .updateUserMetrics(metricsEntity);

        if (context.mounted) {
          if (success) {
            helperUtils.showSnackBar(
              context,
              'Metrics updated successfully!',
              ThemeUtils.$success,
            );
          } else {
            helperUtils.showSnackBar(
              context,
              metricsState.errorMessage ?? 'Failed to update metrics',
              ThemeUtils.$error,
            );
          }
        }
      }
    }

    // Handle create metrics (first time setup)
    Future<void> handleCreateMetrics() async {
      final result = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) => const EditMetricsDialog(currentMetrics: null),
      );

      if (result != null && context.mounted) {
        // Convert Map to UserMetricsEntity
        final metricsEntity = UserMetricsEntity(
          gender: result['gender'],
          age: result['age'],
          weightKG: result['weight_kg'],
          heightCM: result['height_cm'],
          bodyFatPercentage: result['body_fat_percentage'],
          activityLevel: result['activity_level'],
          calculatedTDEE: result['calculated_tdee'],
        );

        final success = await ref
            .read(userMetricsStateProvider.notifier)
            .createUserMetrics(metricsEntity);

        if (context.mounted) {
          if (success) {
            helperUtils.showSnackBar(
              context,
              'Metrics created successfully!',
              ThemeUtils.$success,
            );
          } else {
            helperUtils.showSnackBar(
              context,
              metricsState.errorMessage ?? 'Failed to create metrics',
              ThemeUtils.$error,
            );
          }
        }
      }
    }

    // Handle logout
    void handleLogout() {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            backgroundColor: ThemeUtils.$secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Row(
              children: [
                Icon(
                  FluentIcons.sign_out_24_regular,
                  color: ThemeUtils.$primaryColor,
                ),
                Gap(12),
                Text(
                  'Confirm Logout',
                  style: TextStyle(
                    color: ThemeUtils.$primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: const Text(
              'Are you sure you want to logout?',
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
                  // TODO: Implement logout logic
                  Navigator.of(dialogContext).pop();
                  helperUtils.showSnackBar(
                    context,
                    'Logged out successfully',
                    ThemeUtils.$success,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeUtils.$error,
                  foregroundColor: ThemeUtils.$secondaryColor,
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
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => _showExitConfirmationDialog(context, (pop) {}),
      child: Scaffold(
        backgroundColor: ThemeUtils.$backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: const Icon(Icons.reorder, color: ThemeUtils.$primaryColor),
            ),
          ),
          title: const Text(
            'My Account',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ThemeUtils.$primaryColor,
            ),
          ),
          actions: [
            if (!isEditMode.value && !userState.isLoading)
              IconButton(
                icon: const Icon(
                  FluentIcons.edit_24_regular,
                  color: ThemeUtils.$primaryColor,
                ),
                onPressed: () => isEditMode.value = true,
                tooltip: 'Edit Account Info',
              ),
          ],
        ),
        drawer: UtakulaSideNavigation(),
        body: userState.isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Lottie.asset(
                        'assets/animations/Loading.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Gap(16),
                    Text(
                      "Loading your account...",
                      style: TextStyle(
                        color: ThemeUtils.$primaryColor.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Enhanced Profile Header Card
                    _buildProfileHeader(userState),
                    const Gap(32),

                    // Account Information Section
                    _buildSectionHeader(
                      icon: FluentIcons.person_info_24_regular,
                      title: 'Account Information',
                    ),
                    const Gap(16),
                    _buildAccountInfoSection(
                      userState,
                      isEditMode.value,
                      usernameController,
                      emailController,
                      helperUtils,
                      context,
                    ),

                    const Gap(32),

                    // Health & Metrics Section
                    _buildSectionHeader(
                      icon: FluentIcons.heart_pulse_24_regular,
                      title: 'Health & Metrics',
                      action: metricsState.hasMetrics
                          ? GestureDetector(
                              onTap: handleEditMetrics,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: ThemeUtils.$primaryColor.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      FluentIcons.edit_24_regular,
                                      size: 16,
                                      color: ThemeUtils.$primaryColor,
                                    ),
                                    const Gap(6),
                                    Text(
                                      'Edit',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: ThemeUtils.$primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : null,
                    ),
                    const Gap(16),

                    // Show loading state for metrics
                    if (metricsState.isLoading)
                      Center(
                        child: Column(
                          children: [
                            const CircularProgressIndicator(),
                            const Gap(12),
                            Text(
                              'Loading metrics...',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (metricsState.hasMetrics)
                      _buildMetricsSection(metricsState.userMetrics!)
                    else
                      _buildMetricsEmptyState(handleCreateMetrics),

                    const Gap(32),

                    // Action Buttons
                    if (isEditMode.value) ...[
                      _buildEditModeButtons(
                        userState,
                        isEditMode,
                        usernameController,
                        emailController,
                        handleSave,
                      ),
                    ] else ...[
                      _buildLogoutButton(handleLogout),
                    ],

                    const Gap(20),
                  ],
                ),
              ),
      ),
    );
  }

  // ============================================================================
  // PROFILE HEADER
  // ============================================================================
  Widget _buildProfileHeader(dynamic userState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ThemeUtils.$primaryColor,
            ThemeUtils.$primaryColor.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ThemeUtils.$primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with animated gradient border
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  ThemeUtils.$secondaryColor,
                  ThemeUtils.$secondaryColor.withOpacity(0.6),
                ],
              ),
            ),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: ThemeUtils.$primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  userState.user.username?.substring(0, 1).toUpperCase() ?? 'U',
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: ThemeUtils.$secondaryColor,
                  ),
                ),
              ),
            ),
          ),
          const Gap(16),
          Text(
            userState.user.username ?? 'User',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: ThemeUtils.$secondaryColor,
            ),
          ),
          const Gap(4),
          Text(
            userState.user.email ?? '',
            style: TextStyle(
              fontSize: 14,
              color: ThemeUtils.$secondaryColor.withOpacity(0.8),
            ),
          ),
          const Gap(12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: ThemeUtils.$secondaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: ThemeUtils.$secondaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  userState.user.role == 'admin'
                      ? FluentIcons.shield_checkmark_24_filled
                      : FluentIcons.person_24_regular,
                  color: ThemeUtils.$secondaryColor,
                  size: 18,
                ),
                const Gap(8),
                Text(
                  userState.user.role?.toUpperCase() ?? 'USER',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: ThemeUtils.$secondaryColor,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // SECTION HEADER
  // ============================================================================
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    Widget? action,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ThemeUtils.$primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: ThemeUtils.$primaryColor, size: 20),
        ),
        const Gap(12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ThemeUtils.$primaryColor,
            ),
          ),
        ),
        if (action != null) action,
      ],
    );
  }

  // ============================================================================
  // ACCOUNT INFO SECTION
  // ============================================================================
  Widget _buildAccountInfoSection(
    dynamic userState,
    bool isEditMode,
    TextEditingController usernameController,
    TextEditingController emailController,
    HelperUtils helperUtils,
    BuildContext context,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildEnhancedInfoCard(
                icon: FluentIcons.person_24_regular,
                label: 'Username',
                value: userState.user.username ?? 'N/A',
                iconColor: Colors.blue,
                isEditable: true,
                isEditMode: isEditMode,
                controller: usernameController,
              ),
            ),
            const Gap(12),
            Expanded(
              child: _buildEnhancedInfoCard(
                icon: FluentIcons.mail_24_regular,
                label: 'Email',
                value: userState.user.email ?? 'N/A',
                iconColor: Colors.orange,
                isEditable: true,
                isEditMode: isEditMode,
                controller: emailController,
              ),
            ),
          ],
        ),
        if (userState.user.role == 'admin') ...[
          const Gap(12),
          _buildEnhancedInfoCard(
            icon: FluentIcons.key_24_regular,
            label: 'User ID',
            value: userState.user.id ?? 'N/A',
            iconColor: Colors.purple,
            isEditable: false,
            isEditMode: false,
            showCopyIcon: true,
            onTap: () {
              Clipboard.setData(ClipboardData(text: userState.user.id ?? ''));
              helperUtils.showSnackBar(
                context,
                'User ID copied to clipboard',
                ThemeUtils.$success,
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildEnhancedInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    required bool isEditable,
    required bool isEditMode,
    TextEditingController? controller,
    bool showCopyIcon = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeUtils.$secondaryColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isEditMode && isEditable
                ? ThemeUtils.$primaryColor.withOpacity(0.3)
                : Colors.grey.shade200,
            width: isEditMode && isEditable ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
                const Spacer(),
                if (showCopyIcon)
                  Icon(
                    FluentIcons.copy_24_regular,
                    color: Colors.grey.shade400,
                    size: 16,
                  ),
              ],
            ),
            const Gap(12),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const Gap(4),
            isEditMode && isEditable
                ? TextField(
                    controller: controller,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: ThemeUtils.$primaryColor,
                    ),
                    decoration: const InputDecoration(
                      enabled: false,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: ThemeUtils.$primaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // METRICS SECTION (Updated to use UserMetricsEntity)
  // ============================================================================
  Widget _buildMetricsSection(UserMetricsEntity metrics) {
    final tdee = metrics.calculatedTDEE ?? 0.0;
    final weight = metrics.weightKG ?? 0.0;
    final height = metrics.heightCM ?? 0.0;
    final age = metrics.age ?? 0;
    final bodyFat = metrics.bodyFatPercentage ?? 0.0;
    final activityLevel = metrics.activityLevel ?? 'moderately_active';
    final gender = metrics.gender ?? 'male';

    return Column(
      children: [
        // TDEE Hero Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade600],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      FluentIcons.fire_24_filled,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const Gap(12),
                  const Text(
                    'Your TDEE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Text(
                '${tdee.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              const Gap(4),
              Text(
                'calories/day',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Based on your current metrics',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(16),

        // Metrics Grid
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                icon: FluentIcons.scale_fill_24_regular,
                label: 'Weight',
                value: '${weight.toString()} kg',
                color: Colors.blue,
              ),
            ),
            const Gap(12),
            Expanded(
              child: _buildMetricCard(
                icon: FluentIcons.ruler_24_regular,
                label: 'Height',
                value: '${height.toString()} cm',
                color: Colors.purple,
              ),
            ),
          ],
        ),
        const Gap(12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                icon: FluentIcons.calendar_24_regular,
                label: 'Age',
                value: '$age years',
                color: Colors.orange,
              ),
            ),
            const Gap(12),
            Expanded(
              child: _buildMetricCard(
                icon: FluentIcons.heart_pulse_24_regular,
                label: 'Body Fat',
                value: '${bodyFat.toStringAsFixed(1)}%',
                color: Colors.red,
              ),
            ),
          ],
        ),
        const Gap(12),

        // Activity Level Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ThemeUtils.$secondaryColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  FluentIcons.flash_24_filled,
                  color: Colors.green.shade700,
                  size: 22,
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activity Level',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      _formatActivityLevel(activityLevel),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: gender == 'male'
                      ? Colors.blue.shade50
                      : Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      gender == 'male'
                          ? FluentIcons.person_24_filled
                          : FluentIcons.person_24_regular,
                      size: 14,
                      color: gender == 'male'
                          ? Colors.blue.shade700
                          : Colors.pink.shade700,
                    ),
                    const Gap(6),
                    Text(
                      gender.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: gender == 'male'
                            ? Colors.blue.shade700
                            : Colors.pink.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Gap(12),

        // Last Updated Info
        if (metrics.updatedAt != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FluentIcons.clock_24_regular,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const Gap(6),
                Text(
                  'Last updated: ${_formatDate(metrics.updatedAt)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeUtils.$secondaryColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const Gap(12),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // METRICS EMPTY STATE
  // ============================================================================
  Widget _buildMetricsEmptyState(VoidCallback onSetup) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: ThemeUtils.$secondaryColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ThemeUtils.$primaryColor.withOpacity(0.2),
          width: 2,
          style: BorderStyle.solid,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ThemeUtils.$primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              FluentIcons.heart_pulse_24_filled,
              color: ThemeUtils.$primaryColor,
              size: 48,
            ),
          ),
          const Gap(20),
          const Text(
            'Set Up Your Health Metrics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ThemeUtils.$primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(12),
          Text(
            'Track your body composition and get personalized meal plans based on your fitness goals.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onSetup,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeUtils.$primaryColor,
                foregroundColor: ThemeUtils.$secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FluentIcons.add_circle_24_filled, size: 20),
                  Gap(10),
                  Text(
                    'Get Started',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const Gap(16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildFeatureChip('📊 Track TDEE'),
              _buildFeatureChip('🎯 Set Goals'),
              _buildFeatureChip('📈 Monitor Progress'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ============================================================================
  // ACTION BUTTONS
  // ============================================================================
  Widget _buildEditModeButtons(
    dynamic userState,
    ValueNotifier<bool> isEditMode,
    TextEditingController usernameController,
    TextEditingController emailController,
    VoidCallback handleSave,
  ) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: userState.isSubmitting
                  ? null
                  : () {
                      isEditMode.value = false;
                      usernameController.text = userState.user.username ?? '';
                      emailController.text = userState.user.email ?? '';
                    },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: ThemeUtils.$primaryColor,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ThemeUtils.$primaryColor,
                ),
              ),
            ),
          ),
        ),
        const Gap(12),
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: userState.isSubmitting ? null : handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeUtils.$primaryColor,
                foregroundColor: ThemeUtils.$secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: userState.isSubmitting
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          ThemeUtils.$secondaryColor,
                        ),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FluentIcons.save_24_regular, size: 20),
                        Gap(8),
                        Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(VoidCallback handleLogout) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: handleLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeUtils.$error,
          foregroundColor: ThemeUtils.$secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FluentIcons.sign_out_24_regular, size: 20),
            Gap(10),
            Text(
              'Logout',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================
  String _formatActivityLevel(String level) {
    final map = {
      'sedentary': '😴 Sedentary',
      'lightly_active': '🚶 Lightly Active',
      'moderately_active': '🏃 Moderately Active',
      'very_active': '💪 Very Active',
      'extra_active': '🔥 Extra Active',
    };
    return map[level] ?? level;
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Never';
    // TODO: Format date properly with intl package
    // For now, just return a placeholder
    return 'Recently';
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
