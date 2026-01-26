import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:utakula_v2/common/helpers/helper_utils.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/meal_plan_entity.dart';

class ActionItem extends StatelessWidget {
  const ActionItem({super.key});

  @override
  Widget build(BuildContext context) {
    HelperUtils helperUtils = HelperUtils();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: ThemeUtils.secondaryColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildNavButton(
                context: context,
                icon: FluentIcons.image_24_filled,
                label: "Templates",
                color: ThemeUtils.primaryColor(context),
                onPressed: () {
                  // TODO: Navigate to templates screen
                  // context.push('/meal-templates');
                  helperUtils.showSnackBar(
                    context,
                    "Templates feature coming soon!",
                    ThemeUtils.$info,
                  );
                },
              ),
            ),
            const Gap(12),
            Expanded(
              child: _buildNavButton(
                context: context,
                icon: FluentIcons.people_24_filled,
                label: "Shared",
                color: const Color(0xFF6B4FA0),
                onPressed: () {
                  // TODO: Navigate to shared meal plans screen
                  // context.push('/shared-meal-plans');
                  helperUtils.showSnackBar(
                    context,
                    "Shared feature coming soon!",
                    ThemeUtils.$info,
                  );
                },
              ),
            ),
            const Gap(12),
            Expanded(
              child: _buildNavButton(
                context: context,
                icon: FluentIcons.settings_24_filled,
                label: "More",
                color: const Color(0xFF7C6A46),
                onPressed: () {
                  _showMoreOptions(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 26),
              const Gap(6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeUtils.secondaryColor(context),
      isScrollControlled: false,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: ThemeUtils.secondaryColor(context),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Gap(20),

            // Title
            Text(
              'More Options',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ThemeUtils.primaryColor(context),
              ),
            ),
            const Gap(24),

            // Options
            _buildMoreOption(
              context: context,
              icon: FluentIcons.settings_24_regular,
              label: 'Settings',
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to settings
              },
            ),
            const Gap(12),
            _buildMoreOption(
              context: context,
              icon: FluentIcons.info_24_regular,
              label: 'About',
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to about
              },
            ),
            const Gap(12),
            _buildMoreOption(
              context: context,
              icon: FluentIcons.question_circle_24_regular,
              label: 'Help & Support',
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to help
              },
            ),

            // Add bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: ThemeUtils.backgroundColor(context),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: ThemeUtils.primaryColor(context), size: 24),
            const Gap(16),
            Text(
              label,
              style: TextStyle(
                color: ThemeUtils.primaryColor(context),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Icon(
              FluentIcons.chevron_right_24_regular,
              color: ThemeUtils.primaryColor(context).withOpacity(0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
