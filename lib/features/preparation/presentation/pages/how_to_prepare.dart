import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/day_meal_plan_entity.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/single_meal_plan_entity.dart';
import 'package:utakula_v2/features/preparation/data/models/meal_preparation_model.dart';
import 'package:utakula_v2/features/preparation/domain/entities/meal_preparation_entity.dart';
import 'package:utakula_v2/features/preparation/presentation/providers/meal_preparation_notifier.dart';

class HowToPrepare extends HookConsumerWidget {
  final DayMealPlanEntity selectedPlan;

  const HowToPrepare({super.key, required this.selectedPlan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = Logger();
    final tabController = useTabController(initialLength: 3);
    final mealPreparationStateNotifier = ref.watch(
      mealPreparationStateProvider.notifier,
    );

    final mealPreparationState = ref.watch(mealPreparationStateProvider);

    // State for instructions
    final instructions = useState<Map<String, String>>({});
    final isLoading = useState<Map<String, bool>>({
      'breakfast': false,
      'lunch': false,
      'supper': false,
    });

    final fetchingInstructions = useState(false);

    // Initial page based on time
    final initialPage = useMemoized(() => _getInitialPageBasedOnTime());

    // Fetch instructions for all meals
    Future<void> fetchInstructionsForAllMealTypes() async {
      final mealTypes = ['breakfast', 'lunch', 'supper'];

      for (String mealType in mealTypes) {
        final loadingMap = Map<String, bool>.from(isLoading.value);
        loadingMap[mealType] = true;
        isLoading.value = loadingMap;
        fetchingInstructions.value = true;

        try {
          List<MealTypeFoodEntity> foodsList = _getFoodListForMealType(
            mealType,
          );

          if (foodsList.isNotEmpty) {
            // String contents = foodsList.map((food) => food.foodName).join(', ');

            List<String> foods = foodsList
                .map((food) => food.foodName)
                .toList();

            MealPreparationEntity mealPrepEntity = MealPreparationEntity(
              foodList: foods,
            );

            logger.e("Does it get HERE");

            await mealPreparationStateNotifier.fetchPreparationInstructions(
              mealPrepEntity,
            );

            logger.d(mealPreparationState.instructions);
          }
        } catch (e) {
          logger.e('Error fetching instructions for $mealType: $e');
        } finally {
          final loadingMap = Map<String, bool>.from(isLoading.value);
          loadingMap[mealType] = false;
          isLoading.value = loadingMap;
          fetchingInstructions.value = false;
        }
      }
    }

    // Fetch instructions on mount
    useEffect(() {
      Future.microtask(() => fetchInstructionsForAllMealTypes());
      return null;
    }, []);

    // Set initial tab
    useEffect(() {
      if (tabController.index != initialPage) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          tabController.animateTo(initialPage);
        });
      }
      return null;
    }, []);

    return Scaffold(
      backgroundColor: ThemeUtils.$backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ThemeUtils.$backgroundColor,
        leading: IconButton(
          icon: const Icon(
            FluentIcons.arrow_left_24_filled,
            color: ThemeUtils.$primaryColor,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Preparation Guide",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ThemeUtils.$primaryColor,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: ThemeUtils.$secondaryColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: TabBar(
              controller: tabController,
              indicator: BoxDecoration(
                color: ThemeUtils.$primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: ThemeUtils.$secondaryColor,
              unselectedLabelColor: ThemeUtils.$blacks.withOpacity(0.6),
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Breakfast'),
                Tab(text: 'Lunch'),
                Tab(text: 'Supper'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          _buildMealTab(
            context,
            'breakfast',
            selectedPlan.mealPlan.breakfast,
            instructions.value['breakfast'],
            isLoading.value['breakfast'] ?? false,
          ),
          _buildMealTab(
            context,
            'lunch',
            selectedPlan.mealPlan.lunch,
            instructions.value['lunch'],
            isLoading.value['lunch'] ?? false,
          ),
          _buildMealTab(
            context,
            'supper',
            selectedPlan.mealPlan.supper,
            instructions.value['supper'],
            isLoading.value['supper'] ?? false,
          ),
        ],
      ),
    );
  }

  Widget _buildMealTab(
    BuildContext context,
    String mealType,
    List<MealTypeFoodEntity> foods,
    String? instruction,
    bool loading,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Images Section
          _buildFoodImagesSection(foods),
          const Gap(20),

          // Day Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: ThemeUtils.$primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              selectedPlan.day,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ThemeUtils.$primaryColor,
              ),
            ),
          ),
          const Gap(15),

          // Instructions Section
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ThemeUtils.$secondaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
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
                          color: ThemeUtils.$primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          FluentIcons.book_24_regular,
                          size: 20,
                          color: ThemeUtils.$primaryColor,
                        ),
                      ),
                      const Gap(10),
                      const Text(
                        "Preparation Instructions",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ThemeUtils.$primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const Gap(15),
                  const Divider(height: 1),
                  const Gap(15),
                  Expanded(
                    child: loading
                        ? _buildLoadingState()
                        : instruction != null && instruction.isNotEmpty
                        ? _buildInstructionContent(instruction)
                        : _buildEmptyState(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodImagesSection(List<MealTypeFoodEntity> foods) {
    if (foods.isEmpty) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Text(
            'No foods for this meal',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      height: 140,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeUtils.$primaryColor.withOpacity(0.1),
            ThemeUtils.$secondaryColor.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: foods.map((food) => _buildFoodImage(food)).toList(),
      ),
    );
  }

  Widget _buildFoodImage(MealTypeFoodEntity food) {
    return Align(
      widthFactor: 0.6,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: food.imageUrl.isEmpty
              ? const Icon(FluentIcons.food_24_regular, size: 15)
              : ClipOval(
                  child: Image.asset(
                    'assets/foods/${food.imageUrl}',
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(FluentIcons.food_24_regular, size: 15);
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeUtils.$primaryColor.withOpacity(0.1),
                ),
              ),
              const Icon(
                FluentIcons.circle_24_filled,
                size: 60,
                color: ThemeUtils.$primaryColor,
              ),
            ],
          ),
          const Gap(20),
          const Text(
            'Preparing your recipe...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ThemeUtils.$primaryColor,
            ),
          ),
          const Gap(8),
          Text(
            'This may take a moment',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionContent(String instruction) {
    return SingleChildScrollView(
      child: MarkdownWidget(
        data: instruction,
        shrinkWrap: true,
        selectable: false,
        config: MarkdownConfig(
          configs: [
            // Heading configurations
            H1Config(
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: ThemeUtils.$primaryColor,
              ),
            ),
            H2Config(
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ThemeUtils.$primaryColor,
              ),
            ),
            H3Config(
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ThemeUtils.$primaryColor,
              ),
            ),
            // Paragraph configuration
            PConfig(
              textStyle: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: ThemeUtils.$blacks,
              ),
            ),
            // Blockquote configuration
            BlockquoteConfig(
              padding: const EdgeInsets.all(12),
              sideColor: ThemeUtils.$primaryColor.withOpacity(0.05),

              textColor: ThemeUtils.$secondaryColor,
            ),
            // Code block configuration
            CodeConfig(
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'monospace',
                color: ThemeUtils.$blacks,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FluentIcons.document_dismiss_24_regular,
            size: 60,
            color: Colors.grey[400],
          ),
          const Gap(15),
          Text(
            'Instructions not available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(8),
          Text(
            'Unable to generate preparation guide',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  List<MealTypeFoodEntity> _getFoodListForMealType(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return selectedPlan.mealPlan.breakfast;
      case 'lunch':
        return selectedPlan.mealPlan.lunch;
      case 'supper':
        return selectedPlan.mealPlan.supper;
      default:
        return [];
    }
  }

  int _getInitialPageBasedOnTime() {
    final now = TimeOfDay.now();
    if (now.hour < 11) {
      return 0; // Breakfast
    } else if (now.hour < 14) {
      return 1; // Lunch
    } else {
      return 2; // Supper
    }
  }
}
