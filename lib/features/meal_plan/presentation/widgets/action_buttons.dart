import 'package:flutter/material.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:gap/gap.dart';

class ActionButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSaveDraft;
  final VoidCallback onSaveMealPlan;

  const ActionButtons({
    super.key,
    required this.isLoading,
    required this.onSaveDraft,
    required this.onSaveMealPlan,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              backgroundColor: WidgetStatePropertyAll(
                ThemeUtils.secondaryColor(context),
              ),
            ),
            onPressed: isLoading ? null : onSaveDraft,
            child: Text(
              "Save Draft",
              style: TextStyle(color: ThemeUtils.primaryColor(context)),
            ),
          ),
        ),
        const Gap(10),
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              backgroundColor: WidgetStatePropertyAll(
                ThemeUtils.primaryColor(context),
              ),
            ),
            onPressed: onSaveMealPlan,
            child: Text(
              "Save Meal Plan",
              style: TextStyle(color: ThemeUtils.secondaryColor(context)),
            ),
          ),
        ),
      ],
    );
  }
}
