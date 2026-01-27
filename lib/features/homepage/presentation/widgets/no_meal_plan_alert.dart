import 'package:flutter/cupertino.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/routing/routes.dart';

class NoMealPlanAlert extends StatelessWidget {
  const NoMealPlanAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: ThemeUtils.backgroundColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ThemeUtils.boxShadowColor(context).withOpacity(0.1),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: ThemeUtils.secondaryColor(context).withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/images/food_404.png',
              height: 100,
              width: 100,
            ),
          ),
          const Gap(30),
          Text(
            "No Meal Plan Yet",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ThemeUtils.$error,
            ),
          ),
          const Gap(12),
          Text(
            "Start planning your meals for the week\nand eat healthier!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: ThemeUtils.blacks(context),
              height: 1.5,
            ),
          ),
          const Gap(30),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF2D5016), // Dark green
                  Color(0xFF4A7C2C), // Medium green
                  Color(0xFF7B3FF2), // Purple
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2D5016).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.go(Routes.newPlan);
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Create Your First Plan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(10),
                      Icon(
                        FluentIcons.add_circle_24_regular,
                        color: Colors.white,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
