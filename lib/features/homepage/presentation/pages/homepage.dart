import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/common/global_widgets/utakula_exit_alert.dart';
import 'package:utakula_v2/common/global_widgets/utakula_logout_popup.dart';
import 'package:utakula_v2/common/global_widgets/utakula_side_navigation.dart';
import 'package:utakula_v2/common/helpers/helper_utils.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/account/presentation/providers/user_providers.dart';
import 'package:utakula_v2/features/homepage/presentation/providers/homepage_providers.dart';
import 'package:utakula_v2/features/homepage/presentation/widgets/action_item.dart';
import 'package:utakula_v2/features/homepage/presentation/widgets/days_widget.dart';
import 'package:utakula_v2/features/homepage/presentation/widgets/meal_plan_error.dart';
import 'package:utakula_v2/features/homepage/presentation/widgets/no_meal_plan_alert.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/day_meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/presentation/providers/meal_plan_provider.dart';

class Homepage extends HookConsumerWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Logger logger = Logger();
    final mealPlanState = ref.watch(mealPlanStateProvider);
    final homePageState = ref.watch(homepageStateProvider);
    final userState = ref.watch(userStateProvider);

    HelperUtils helperUtils = HelperUtils();

    // Listen to state changes and show snackbars accordingly
    ref.listen<MealPlanState>(mealPlanStateProvider, (previous, next) {
      // Only show snackbar if context is mounted
      if (!context.mounted) return;

      // Show success message
      if (next.currentMealPlan!.mealPlan.isNotEmpty &&
          next.currentMealPlan != previous?.currentMealPlan) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            helperUtils.showSnackBar(
              context,
              "Meal plan loaded Successfully",
              ThemeUtils.$success,
            );
          }
        });
      }

      // Show error message
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            helperUtils.showSnackBar(
              context,
              next.errorMessage!,
              ThemeUtils.$error,
            );
          }
        });
      }
    });

    useEffect(() {
      Future.microtask(() async {
        await ref.read(userStateProvider.notifier).getUserAccountDetails();
        await ref.read(mealPlanStateProvider.notifier).fetchMealPlan();

        // Initialize homepage state with first day after meal plan loads
        final currentMealPlan = ref.read(mealPlanStateProvider).currentMealPlan;
        if (currentMealPlan != null && currentMealPlan.mealPlan.isNotEmpty) {
          ref
              .read(homepageStateProvider.notifier)
              .initializeWithFirstDay(currentMealPlan.mealPlan.first);
        }
      });
      return null;
    }, []);

    final bool isFetchingMealPlan = mealPlanState.isLoading;
    final bool isLoadingUser = userState.isLoading;
    final String? errorMessage = mealPlanState.errorMessage;
    final MealPlanEntity? myMealPlan = mealPlanState.currentMealPlan;
    final DayMealPlanEntity? selectedPlan = homePageState.selectedMealPlan;
    final List sharedMealPlans = [];

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => _showExitConfirmationDialog(context, (pop) {}),
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
        drawer: UtakulaSideNavigation(),
        body: RefreshIndicator(
          onRefresh: () async {
            await ref.read(mealPlanStateProvider.notifier).fetchMealPlan();
          },
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  // Welcome Banner
                  _buildWelcomeBanner(
                    context: context,
                    isLoadingUser: isLoadingUser,
                    userState: userState,
                  ),
                  const Gap(15),
                  // Info Banner
                  _buildInfoBanner(),
                  const Gap(20),
                  // Main Content Area
                  _buildMainContent(
                    context,
                    isFetchingMealPlan,
                    errorMessage,
                    myMealPlan,
                    selectedPlan,
                    sharedMealPlans,
                    ref,
                  ),
                  const Gap(25),
                  _buildActionItems(context),
                ],
              ),
            ),
          ),
        ),
        // bottomNavigationBar: BottomAppBar(
        //   height: 140,
        //   color: ThemeUtils.$secondaryColor,
        //   elevation: 0,
        //   shape: const CircularNotchedRectangle(),
        //   child: _buildActionItems(context),
        // ),
      ),
    );
  }

  Widget _buildWelcomeBanner({
    required BuildContext context,
    required bool isLoadingUser,
    required UserState userState,
  }) {
    // Use useState for slider position
    final sliderPosition = useState(0.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D5016), Color(0xFF4A7C2C)],
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
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          sliderPosition.value += details.delta.dx;

          // Get context width for threshold calculation
          final screenWidth = MediaQuery.of(context).size.width;

          // Trigger logout prompt if slider reaches end (60% of screen width)
          if (sliderPosition.value > screenWidth * 0.5) {
            showLogoutDialog(ValueNotifier(false), context);
            sliderPosition.value = 0.0; // Reset slider
          }
        },
        onHorizontalDragEnd: (_) {
          sliderPosition.value = 0.0; // Reset slider on drag end
        },
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Background with username
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Opacity(
                  opacity: 0.3,
                  child: Container(
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
                ),
                Text(
                  isLoadingUser
                      ? 'Loading . . .'
                      : userState.user.username ?? 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Sliding "Welcome Back!" container
            Positioned(
              left: sliderPosition.value,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    color: Color(0xFF2D5016),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
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
    String? errorMessage,
    MealPlanEntity? myMealPlan,
    DayMealPlanEntity? selectedPlan,
    List sharedMealPlans,
    WidgetRef ref,
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
          : myMealPlan == null ||
                errorMessage != null &&
                    errorMessage.startsWith("Unexpected error")
          ? MealPlanError()
          : errorMessage == "User does not have meal plan!"
          ? const NoMealPlanAlert()
          : _buildDaysWidget(
              context,
              selectedPlan,
              myMealPlan,
              sharedMealPlans,
              ref,
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
    DayMealPlanEntity? selectedPlan,
    MealPlanEntity myMealPlan,
    List sharedMealPlans,
    WidgetRef ref,
  ) {
    return DaysWidget(
      selectedPlan: selectedPlan,
      myMealPlan: myMealPlan,
      sharedPlans: sharedMealPlans,
    );
  }

  Widget _buildActionItems(BuildContext context) {
    return ActionItem();
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

  void showLogoutDialog(ValueNotifier<bool> loggingOut, BuildContext context) {
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
}
