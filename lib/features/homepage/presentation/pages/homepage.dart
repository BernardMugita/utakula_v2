import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/homepage/presentation/widgets/action_item.dart';
import 'package:utakula_v2/features/homepage/presentation/widgets/days_widget.dart';
import 'package:utakula_v2/features/homepage/presentation/widgets/no_meal_plan_alert.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    // These would come from Riverpod providers
    final bool isFetchingMealPlan = false;
    final Map<String, dynamic> myMealPlan = {};
    final Map selectedPlan = {};
    final List sharedMealPlans = [];

    return RefreshIndicator(
      onRefresh: () async {
        // Hook up your refresh logic here
      },
      child: Scaffold(
        backgroundColor: ThemeUtils.$accentColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: const Icon(Icons.reorder),
            ),
          ),
        ),
        body: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                // Welcome Banner (Hamburger + User greeting)
                _buildWelcomeBanner(),
                const Gap(15),

                // Info Banner
                _buildInfoBanner(),
                const Gap(20),

                // Main Content Area
                _buildMainContent(
                  context,
                  isFetchingMealPlan,
                  myMealPlan,
                  selectedPlan,
                  sharedMealPlans,
                ),
                const Gap(25),

                // Action Items
                if (!isFetchingMealPlan) _buildActionItems(context, myMealPlan),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2D5016), // Dark green
            Color(0xFF4A7C2C), // Medium green
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Welcome Back!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Text(
            'JeromeMugita',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),
      ),
      child: const Row(
        children: [
          Icon(FluentIcons.info_24_regular, color: Colors.black87, size: 20),
          Gap(10),
          Text(
            "Slide to logout",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    bool isFetchingMealPlan,
    Map<String, dynamic> myMealPlan,
    Map selectedPlan,
    List sharedMealPlans,
  ) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height / 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: isFetchingMealPlan
          ? _buildLoadingState()
          : myMealPlan.isNotEmpty
          ? const NoMealPlanAlert()
          : _buildDaysWidget(
              context,
              selectedPlan,
              myMealPlan,
              sharedMealPlans,
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: ThemeUtils.$primaryColor,
              strokeWidth: 3,
            ),
            const Gap(20),
            Text(
              'Loading your meal plan...',
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysWidget(
    BuildContext context,
    Map selectedPlan,
    Map<String, dynamic> myMealPlan,
    List sharedMealPlans,
  ) {
    return DaysWidget();
  }

  Widget _buildActionItems(
    BuildContext context,
    Map<String, dynamic> myMealPlan,
  ) {
    return ActionItem(myMealPlan: myMealPlan);
  }
}
