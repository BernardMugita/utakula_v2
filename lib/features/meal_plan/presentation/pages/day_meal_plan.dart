import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:utakula_v2/common/themes/theme_utils.dart';
import 'package:utakula_v2/features/foods/domain/entities/food_entity.dart';
import 'package:utakula_v2/features/foods/presentation/providers/foods_provider.dart';
import 'package:utakula_v2/features/homepage/presentation/widgets/meal_breakdown_dialog.dart';
import 'package:utakula_v2/features/meal_plan/presentation/widgets/food_portion_dialog.dart';

class DayMealPlan extends HookConsumerWidget {
  final String day;
  final Map meals;
  final Function(Map<String, dynamic>, double calories) onSave;

  const DayMealPlan({
    super.key,
    required this.day,
    required this.meals,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final foodState = ref.watch(foodStateProvider);
    final mealPlan = useState<Map<String, List<Map<String, dynamic>>>>({
      'breakfast': List<Map<String, dynamic>>.from(meals['breakfast'] ?? []),
      'lunch': List<Map<String, dynamic>>.from(meals['lunch'] ?? []),
      'supper': List<Map<String, dynamic>>.from(meals['supper'] ?? []),
    });

    useEffect(() {
      Future.microtask(() => ref.read(foodStateProvider.notifier).fetchFoods());
      return null;
    }, []);

    // Calculate total calories
    double calculateMealCalories(List<Map<String, dynamic>> mealItems) {
      final total = mealItems.fold<double>(0.0, (sum, item) {
        final calories =
            (item['total_calories'] as num? ?? item['calories'] as num? ?? 0)
                .toDouble();

        return sum + calories;
      });

      return double.parse(total.round().toStringAsFixed(1));
    }

    double getTotalCalories() {
      return calculateMealCalories(mealPlan.value['breakfast']!) +
          calculateMealCalories(mealPlan.value['lunch']!) +
          calculateMealCalories(mealPlan.value['supper']!);
    }

    void handleSave() {
      final meals = Map<String, dynamic>.from(mealPlan.value);
      final totalCals = getTotalCalories()
          .toDouble();

      Logger().d('=== SAVING MEAL PLAN ===');
      Logger().d('Day: $day');
      Logger().d('Meals: $meals');
      Logger().d('Total Calories: $totalCals');

      onSave(meals, totalCals);
      Navigator.pop(context);
    }

    Logger logger = Logger();

    return Scaffold(
      backgroundColor: ThemeUtils.$backgroundColor,
      appBar: AppBar(
        backgroundColor: ThemeUtils.$primaryColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            FluentIcons.arrow_left_24_regular,
            color: ThemeUtils.$secondaryColor,
          ),
        ),
        title: Text(
          "$day Meal Plan",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ThemeUtils.$secondaryColor,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: handleSave,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: ThemeUtils.$secondaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    FluentIcons.save_24_regular,
                    size: 18,
                    color: ThemeUtils.$secondaryColor,
                  ),
                  const Gap(6),
                  Text(
                    "Save",
                    style: TextStyle(
                      color: ThemeUtils.$secondaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: foodState.isLoading
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
                    "Loading delicious foods...",
                    style: TextStyle(
                      color: ThemeUtils.$primaryColor.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : Row(
              children: [
                // Left side - Food items
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  decoration: BoxDecoration(
                    color: ThemeUtils.$secondaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(2, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ThemeUtils.$primaryColor.withOpacity(0.1),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              FluentIcons.food_24_regular,
                              color: ThemeUtils.$primaryColor,
                              size: 20,
                            ),
                            const Gap(8),
                            const Text(
                              "Foods",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: ThemeUtils.$primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: foodState.foods.isEmpty
                            ? Center(
                                child: Text(
                                  "No foods available",
                                  style: TextStyle(
                                    color: ThemeUtils.$primaryColor.withOpacity(
                                      0.5,
                                    ),
                                  ),
                                ),
                              )
                            : Scrollbar(
                                controller: scrollController,
                                thumbVisibility: true,
                                thickness: 8.0,
                                radius: const Radius.circular(20),
                                interactive: true,
                                child: ListView.builder(
                                  controller: scrollController,
                                  // Connect the same controller
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    right: 10,
                                    top: 8,
                                    bottom: 8,
                                  ),
                                  itemCount: foodState.foods.length,
                                  itemBuilder: (context, index) {
                                    final food = foodState.foods[index];
                                    return DraggableFoodItem(food: food);
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                // Right side - Meal sections
                Expanded(
                  child: Container(
                    color: ThemeUtils.$backgroundColor,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Total calories card
                          Container(
                            padding: const EdgeInsets.all(16),
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
                                  color: ThemeUtils.$primaryColor.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: ThemeUtils.$secondaryColor
                                            .withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        FluentIcons.fire_24_filled,
                                        color: ThemeUtils.$secondaryColor,
                                        size: 24,
                                      ),
                                    ),
                                    const Gap(12),
                                    // const Text(
                                    //   "Calories",
                                    //   style: TextStyle(
                                    //     color: ThemeUtils.$secondaryColor,
                                    //     fontSize: 16,
                                    //     fontWeight: FontWeight.w600,
                                    //   ),
                                    // ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ThemeUtils.$secondaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "${getTotalCalories()} cal",
                                    style: const TextStyle(
                                      color: ThemeUtils.$primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(20),
                          // Meal sections
                          ...['breakfast', 'lunch', 'supper'].map((mealType) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: MealSection(
                                mealType: mealType,
                                mealItems: mealPlan.value[mealType]!,
                                onAccept: (Map<String, dynamic> foodData) {
                                  mealPlan.value = {
                                    ...mealPlan.value,
                                    mealType: [
                                      ...mealPlan.value[mealType]!,
                                      foodData,
                                    ],
                                  };
                                },
                                onRemove: (index) {
                                  final updated =
                                      List<Map<String, dynamic>>.from(
                                        mealPlan.value[mealType]!,
                                      );
                                  updated.removeAt(index);
                                  mealPlan.value = {
                                    ...mealPlan.value,
                                    mealType: updated,
                                  };
                                },
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class DraggableFoodItem extends StatelessWidget {
  final FoodEntity food;

  const DraggableFoodItem({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Show portion dialog on tap instead of drag
        final result = await showDialog<Map<String, dynamic>>(
          context: context,
          builder: (context) => FoodPortionDialog(food: food),
        );
      },
      child: Draggable<FoodEntity>(
        data: food,
        feedback: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 100,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ThemeUtils.$primaryColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                food.imageUrl != null
                    ? Image.asset(
                        "assets/foods/${food.imageUrl}",
                        width: 30,
                        height: 30,
                        errorBuilder: (_, __, ___) =>
                            const Text('🍽️', style: TextStyle(fontSize: 24)),
                      )
                    : const Text('🍽️', style: TextStyle(fontSize: 24)),
                const Gap(4),
                Text(
                  food.name ?? 'Unknown',
                  style: const TextStyle(
                    color: ThemeUtils.$secondaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        childWhenDragging: Opacity(opacity: 0.5, child: _buildFoodCard()),
        child: _buildFoodCard(),
      ),
    );
  }

  Widget _buildFoodCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeUtils.$backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeUtils.$primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            food.name ?? 'Unknown',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: ThemeUtils.$primaryColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const Gap(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  color: ThemeUtils.$primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: food.imageUrl != null
                      ? Image.asset("assets/foods/${food.imageUrl}")
                      : const Text('🍽️', style: TextStyle(fontSize: 24)),
                ),
              ),
              const Gap(4),
              Text(
                "${food.calories?.total ?? 0} cal/100g",
                style: TextStyle(
                  fontSize: 11,
                  color: ThemeUtils.$primaryColor.withOpacity(0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MealSection extends StatelessWidget {
  final String mealType;
  final List<Map<String, dynamic>> mealItems;
  final Function(Map<String, dynamic>) onAccept;
  final Function(int) onRemove;

  const MealSection({
    super.key,
    required this.mealType,
    required this.mealItems,
    required this.onAccept,
    required this.onRemove,
  });

  String get mealLabel {
    return mealType[0].toUpperCase() + mealType.substring(1);
  }

  IconData get mealIcon {
    switch (mealType) {
      case 'breakfast':
        return FluentIcons.food_24_regular;
      case 'lunch':
        return FluentIcons.bowl_salad_24_regular;
      case 'supper':
        return FluentIcons.food_24_filled;
      default:
        return FluentIcons.food_24_regular;
    }
  }

  double get totalCalories {
    return mealItems.fold<double>(
      0,
      (sum, item) => sum + ((item['calories'] as num?)?.toDouble() ?? 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<FoodEntity>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) async {
        // Show portion dialog when food is dropped
        final result = await showDialog<Map<String, dynamic>>(
          context: context,
          builder: (context) => FoodPortionDialog(food: details.data),
        );

        if (result != null) {
          onAccept(result); // Pass the nutrition map directly
        }
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return Container(
          height: 200,
          decoration: BoxDecoration(
            color: ThemeUtils.$secondaryColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isHovering
                  ? ThemeUtils.$primaryColor
                  : ThemeUtils.$primaryColor.withOpacity(0.1),
              width: isHovering ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ThemeUtils.$primaryColor.withOpacity(0.05),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          mealIcon,
                          color: ThemeUtils.$primaryColor,
                          size: 20,
                        ),
                        const Gap(8),
                        Text(
                          mealLabel,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ThemeUtils.$primaryColor,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: mealItems.isEmpty
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (context) => MealBreakdownDialog(
                                  mealType: mealLabel,
                                  foods: mealItems,
                                ),
                              );
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: ThemeUtils.$primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "$totalCalories cal",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: ThemeUtils.$primaryColor,
                              ),
                            ),
                            if (mealItems.isNotEmpty) ...[
                              const Gap(4),
                              Icon(
                                FluentIcons.chevron_right_24_regular,
                                size: 14,
                                color: ThemeUtils.$primaryColor,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: mealItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FluentIcons.add_circle_24_regular,
                                color: ThemeUtils.$primaryColor.withOpacity(
                                  0.3,
                                ),
                                size: 32,
                              ),
                              const Gap(8),
                              Text(
                                "Drag foods here",
                                style: TextStyle(
                                  color: ThemeUtils.$primaryColor.withOpacity(
                                    0.5,
                                  ),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: mealItems.asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value;
                              return _buildMealItem(item, index);
                            }).toList(),
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMealItem(Map<String, dynamic> item, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ThemeUtils.$backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeUtils.$primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/foods/${item['image_url']}',
            height: 20,
            width: 20,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(FluentIcons.food_24_regular, size: 15);
            },
          ),
          const Gap(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  item['name'] ?? 'Unknown',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: ThemeUtils.$primaryColor,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    "${item['grams']?.toStringAsFixed(0) ?? 0}g",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    " • ${(item['calories'] ?? item['total_calories'])?.toStringAsFixed(0) ?? 0} cal",
                    style: TextStyle(
                      fontSize: 10,
                      color: ThemeUtils.$primaryColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Gap(8),
          GestureDetector(
            onTap: () => onRemove(index),
            child: Icon(
              FluentIcons.dismiss_circle_24_filled,
              size: 20,
              color: ThemeUtils.$error,
            ),
          ),
        ],
      ),
    );
  }
}
