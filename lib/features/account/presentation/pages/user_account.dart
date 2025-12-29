import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:utakula_v2/common/global_widgets/utakula_side_navigation.dart';
import 'package:utakula_v2/common/helpers/helper_utils.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/account/domain/entities/user_entity.dart';
import 'package:utakula_v2/features/account/presentation/providers/user_providers.dart';

class UserAccount extends HookConsumerWidget {
  const UserAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = Logger();
    final helperUtils = HelperUtils();
    final userState = ref.watch(userStateProvider);

    // State management for edit mode
    final isEditMode = useState(false);
    final usernameController = useTextEditingController();
    final emailController = useTextEditingController();

    // Fetch user data on mount
    useEffect(() {
      Future.microtask(
        () => ref.read(userStateProvider.notifier).getUserAccountDetails(),
      );
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

    // Handle save
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

    return Scaffold(
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
                  // Profile Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ThemeUtils.$primaryColor,
                          ThemeUtils.$primaryColor.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: ThemeUtils.$primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Avatar
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: ThemeUtils.$secondaryColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ThemeUtils.$secondaryColor,
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              userState.user.username
                                      ?.substring(0, 1)
                                      .toUpperCase() ??
                                  'U',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: ThemeUtils.$secondaryColor,
                              ),
                            ),
                          ),
                        ),
                        const Gap(16),
                        Text(
                          userState.user.username ?? 'User',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: ThemeUtils.$secondaryColor,
                          ),
                        ),
                        const Gap(8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: ThemeUtils.$secondaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                userState.user.role == 'admin'
                                    ? FluentIcons.shield_checkmark_24_filled
                                    : FluentIcons.person_24_regular,
                                color: ThemeUtils.$secondaryColor,
                                size: 16,
                              ),
                              const Gap(6),
                              Text(
                                userState.user.role?.toUpperCase() ?? 'USER',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeUtils.$secondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Gap(24),

                  // Account Information Section
                  const Text(
                    'Account Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ThemeUtils.$primaryColor,
                    ),
                  ),
                  const Gap(12),

                  // Username Card
                  _buildInfoCard(
                    icon: FluentIcons.person_24_regular,
                    label: 'Username',
                    value: userState.user.username ?? 'N/A',
                    isEditable: true,
                    isEditMode: isEditMode.value,
                    controller: usernameController,
                  ),

                  const Gap(12),

                  // Email Card
                  _buildInfoCard(
                    icon: FluentIcons.mail_24_regular,
                    label: 'Email',
                    value: userState.user.email ?? 'N/A',
                    isEditable: true,
                    isEditMode: isEditMode.value,
                    controller: emailController,
                  ),

                  const Gap(12),

                  // User ID Card
                  _buildInfoCard(
                    icon: FluentIcons.key_24_regular,
                    label: 'User ID',
                    value: userState.user.id ?? 'N/A',
                    isEditable: false,
                    isEditMode: false,
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(text: userState.user.id ?? ''),
                      );
                      helperUtils.showSnackBar(
                        context,
                        'User ID copied to clipboard',
                        ThemeUtils.$success,
                      );
                    },
                  ),

                  const Gap(12),

                  // Device Token Card (only for admin)
                  if (userState.user.role == 'admin')
                    _buildInfoCard(
                      icon: FluentIcons.phone_24_regular,
                      label: 'Device Token',
                      value: userState.user.deviceToken != null
                          ? '${userState.user.deviceToken!.substring(0, 20)}...'
                          : 'N/A',
                      isEditable: false,
                      isEditMode: false,
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(text: userState.user.deviceToken ?? ''),
                        );
                        helperUtils.showSnackBar(
                          context,
                          'Device token copied to clipboard',
                          ThemeUtils.$success,
                        );
                      },
                    ),

                  const Gap(32),

                  // Action Buttons
                  if (isEditMode.value) ...[
                    // Save and Cancel buttons
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: OutlinedButton(
                              onPressed: userState.isSubmitting
                                  ? null
                                  : () {
                                      isEditMode.value = false;
                                      usernameController.text =
                                          userState.user.username ?? '';
                                      emailController.text =
                                          userState.user.email ?? '';
                                    },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: ThemeUtils.$primaryColor,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
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
                              onPressed: userState.isSubmitting
                                  ? null
                                  : handleSave,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeUtils.$primaryColor,
                                foregroundColor: ThemeUtils.$secondaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 4,
                                shadowColor: ThemeUtils.$primaryColor
                                    .withOpacity(0.3),
                              ),
                              child: userState.isSubmitting
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              ThemeUtils.$secondaryColor,
                                            ),
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FluentIcons.save_24_regular,
                                          size: 20,
                                        ),
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
                    ),
                  ] else ...[
                    // Logout button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: handleLogout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeUtils.$error,
                          foregroundColor: ThemeUtils.$secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 4,
                          shadowColor: ThemeUtils.$error.withOpacity(0.3),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(FluentIcons.sign_out_24_regular, size: 20),
                            Gap(8),
                            Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required bool isEditable,
    required bool isEditMode,
    TextEditingController? controller,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeUtils.$secondaryColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ThemeUtils.$primaryColor.withOpacity(0.1)),
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
                color: ThemeUtils.$primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: ThemeUtils.$primaryColor, size: 24),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeUtils.$primaryColor.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(4),
                  isEditMode && isEditable
                      ? TextField(
                          controller: controller,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ThemeUtils.$primaryColor,
                          ),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                        )
                      : Text(
                          value,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ThemeUtils.$primaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                FluentIcons.copy_24_regular,
                color: ThemeUtils.$primaryColor.withOpacity(0.5),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
