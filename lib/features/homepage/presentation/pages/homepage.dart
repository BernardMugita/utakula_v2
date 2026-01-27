import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:utakula_v2/common/global_widgets/utakula_exit_alert.dart';
import 'package:utakula_v2/common/global_widgets/utakula_logout_popup.dart';
import 'package:utakula_v2/common/global_widgets/utakula_side_navigation.dart';
import 'package:utakula_v2/common/helpers/helper_utils.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/account/presentation/providers/user_metrics_provider.dart';
import 'package:utakula_v2/features/account/presentation/providers/user_providers.dart';
import 'package:utakula_v2/features/homepage/presentation/providers/homepage_providers.dart';
import 'package:utakula_v2/features/homepage/presentation/widgets/action_item.dart';
import 'package:utakula_v2/features/homepage/presentation/widgets/days_widget.dart';
import 'package:utakula_v2/features/homepage/presentation/widgets/meal_plan_error.dart';
import 'package:utakula_v2/features/homepage/presentation/widgets/no_meal_plan_alert.dart';
import 'package:utakula_v2/features/homepage/presentation/widgets/metrics_setup_prompt.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/day_meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/presentation/providers/meal_plan_provider.dart';
import 'package:utakula_v2/routing/routes.dart';

class Homepage extends HookConsumerWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Logger logger = Logger();
    final mealPlanState = ref.watch(mealPlanStateProvider);
    final homePageState = ref.watch(homepageStateProvider);
    final userState = ref.watch(userStateProvider);
    final metricsState = ref.watch(userMetricsStateProvider);

    HelperUtils helperUtils = HelperUtils();

    // Listen to state changes and show snackbars accordingly
    ref.listen<MealPlanState>(mealPlanStateProvider, (previous, next) {
      if (!context.mounted) return;

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
        await ref.read(userMetricsStateProvider.notifier).getUserMetrics();
        await ref.read(mealPlanStateProvider.notifier).fetchMealPlan();

        final currentMealPlan = ref.read(mealPlanStateProvider).currentMealPlan;
        if (currentMealPlan != null && currentMealPlan.mealPlan.isNotEmpty) {
          ref
              .read(homepageStateProvider.notifier)
              .initializeWithFirstDay(currentMealPlan.mealPlan.first);
        }
      });
      return null;
    }, []);

    // Check if all initial loading is complete
    final bool isInitialLoading =
        userState.isLoading ||
        metricsState.isLoading ||
        mealPlanState.isLoading;

    // Show full-screen loading state until everything is loaded
    if (isInitialLoading) {
      return Scaffold(
        backgroundColor: ThemeUtils.backgroundColor(context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 250,
                height: 250,
                child: Lottie.asset(
                  'assets/animations/Loading.json',
                  fit: BoxFit.contain,
                ),
              ),
              const Gap(20),
              Text(
                'Preparing your meal plan...',
                style: TextStyle(
                  color: ThemeUtils.primaryColor(context).withOpacity(0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(8),
              Text(
                'Almost there!',
                style: TextStyle(
                  color: ThemeUtils.primaryColor(context).withOpacity(0.5),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Once loading is complete, extract all the state variables
    final String? errorMessage = mealPlanState.errorMessage;
    final MealPlanEntity? myMealPlan = mealPlanState.currentMealPlan;
    final DayMealPlanEntity? selectedPlan = homePageState.selectedMealPlan;
    final List sharedMealPlans = [];

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
            await ref.read(userMetricsStateProvider.notifier).getUserMetrics();
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
                  _buildWelcomeBanner(context: context, userState: userState),
                  const Gap(15),
                  // Info Banner
                  _buildInfoBanner(context),
                  const Gap(20),

                  // Metrics Setup Prompt (if no metrics)
                  if (!metricsState.hasMetrics) ...[
                    MetricsSetupPrompt(
                      onSetupTap: () => context.push(Routes.account),
                    ),
                    const Gap(20),
                  ],

                  // Main Content Area
                  _buildMainContent(
                    context,
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
      ),
    );
  }

  Widget _buildWelcomeBanner({
    required BuildContext context,
    required UserState userState,
  }) {
    final sliderPosition = useState(0.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0C6202), Color(0xFF022C00)],
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
          final screenWidth = MediaQuery.of(context).size.width;

          if (sliderPosition.value > screenWidth * 0.5) {
            showLogoutDialog(ValueNotifier(false), context);
            sliderPosition.value = 0.0;
          }
        },
        onHorizontalDragEnd: (_) {
          sliderPosition.value = 0.0;
        },
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Row(
              spacing: 5,
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
                SizedBox(
                  width: 60,
                  height: 30,
                  child: Row(
                    children: [
                      Lottie.asset("assets/animations/slide.json"),
                      Lottie.asset("assets/animations/slide.json"),
                    ],
                  ),
                ),
                Spacer(),
                Text(
                  userState.user.username ?? 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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

  Widget _buildInfoBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: ThemeUtils.secondaryColor(context).withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Icon(
            FluentIcons.info_24_regular,
            color: ThemeUtils.blacks(context),
            size: 20,
          ),
          Gap(10),
          Text(
            "Slide to logout",
            style: TextStyle(
              color: ThemeUtils.blacks(context),
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
      child:
          myMealPlan == null ||
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
          onPop: () async {},
        );
      },
    );
  }
}
