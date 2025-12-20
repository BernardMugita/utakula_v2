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

class DayMealPlan extends HookConsumerWidget {
  final String day;
  final Map meals;
  final Function(Map<String, dynamic>) onSave;

  const DayMealPlan({
    super.key,
    required this.day,
    required this.meals,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    int calculateMealCalories(List<Map<String, dynamic>> mealItems) {
      return mealItems.fold(
        0,
        (sum, item) => sum + (item['calories'] as int? ?? 0),
      );
    }

    int getTotalCalories() {
      return calculateMealCalories(mealPlan.value['breakfast']!) +
          calculateMealCalories(mealPlan.value['lunch']!) +
          calculateMealCalories(mealPlan.value['supper']!);
    }

    void handleSave() {
      onSave(Map<String, dynamic>.from(mealPlan.value));
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
                            : ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: foodState.foods.length,
                                itemBuilder: (context, index) {
                                  final food = foodState.foods[index];
                                  return DraggableFoodItem(food: food);
                                },
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
                                    const Text(
                                      "Calories",
                                      style: TextStyle(
                                        color: ThemeUtils.$secondaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
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
                                onAccept: (FoodEntity food) {
                                  // Convert FoodEntity to Map format with all required fields
                                  final foodMap = {
                                    'id': food.id ?? '',
                                    // Include the food ID
                                    'name': food.name ?? 'Unknown',
                                    'emoji': '🍽️',
                                    // Default emoji, you might want to add emoji field to FoodEntity
                                    'calories': food.calories?.total ?? 0,
                                    'imageUrl': food.imageUrl ?? '',
                                    'image_url': food.imageUrl ?? '',
                                    // Include both formats for compatibility
                                  };

                                  mealPlan.value = {
                                    ...mealPlan.value,
                                    mealType: [
                                      ...mealPlan.value[mealType]!,
                                      foodMap,
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
    return Draggable<FoodEntity>(
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
              Text('🍽️', style: const TextStyle(fontSize: 8)),
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
      child: Row(
        children: [
          Container(
            width: 50,
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
          const Gap(12),
          Expanded(
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
                const Gap(4),
                Text(
                  "${food.calories?.total ?? 0} cal",
                  style: TextStyle(
                    fontSize: 11,
                    color: ThemeUtils.$primaryColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MealSection extends StatelessWidget {
  final String mealType;
  final List<Map<String, dynamic>> mealItems;
  final Function(FoodEntity) onAccept;
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

  int get totalCalories {
    return mealItems.fold(
      0,
      (sum, item) => sum + (item['calories'] as int? ?? 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<FoodEntity>(
      onAccept: onAccept,
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeUtils.$primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "$totalCalories cal",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: ThemeUtils.$primaryColor,
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
                width: 120,
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
              Text(
                "${item['calories'] ?? 0} cal",
                style: TextStyle(
                  fontSize: 10,
                  color: ThemeUtils.$primaryColor.withOpacity(0.6),
                ),
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
