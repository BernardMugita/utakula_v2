import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ActionItem extends StatelessWidget {
  final Map<String, dynamic> myMealPlan;

  const ActionItem({super.key, required this.myMealPlan});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (myMealPlan.isNotEmpty &&
            myMealPlan['meal_plan']?.isNotEmpty == true)
          _buildActionButton(
            context: context,
            icon: FluentIcons.people_add_24_regular,
            label: 'Invite your family/friends',
            backgroundColor: Colors.white,
            textColor: const Color(0xFF2D5016),
            iconColor: const Color(0xFF2D5016),
            onPressed: () {
              // Navigation logic
            },
          ),
        if (myMealPlan.isNotEmpty &&
            myMealPlan['meal_plan']?.isNotEmpty == true)
          const Gap(12),
        _buildActionButton(
          context: context,
          icon: FluentIcons.image_24_regular,
          label: 'Meal Templates',
          backgroundColor: Colors.white,
          textColor: const Color(0xFF2D5016),
          iconColor: const Color(0xFF2D5016),
          onPressed: () {
            // Navigation logic
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E8E8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
