import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:utakula_v2/features/meal_plan/domain/entities/day_meal_plan_entity.dart';

class HomepageState {
  final DayMealPlanEntity? selectedMealPlan;
  final String? selectedDay;
  final bool isExpanded;

  const HomepageState({
    this.selectedMealPlan,
    this.selectedDay,
    this.isExpanded = false,
  });

  HomepageState copyWith({
    DayMealPlanEntity? selectedMealPlan,
    String? selectedDay,
    bool? isExpanded,
    bool clearSelection = false,
  }) {
    return HomepageState(
      selectedMealPlan: clearSelection ? null : (selectedMealPlan ?? this.selectedMealPlan),
      selectedDay: clearSelection ? null : (selectedDay ?? this.selectedDay),
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

class HomepageNotifier extends Notifier<HomepageState> {
  @override
  HomepageState build() {
    return const HomepageState();
  }

  Logger logger = Logger();

  /// Set the active meal plan for a specific day
  void selectDayMealPlan(DayMealPlanEntity dayMealPlanEntity) {
    state = state.copyWith(
      selectedMealPlan: dayMealPlanEntity,
      selectedDay: dayMealPlanEntity.day,
      isExpanded: true,
    );
    logger.i('Selected meal plan for day: ${dayMealPlanEntity.day}');
  }

  /// Toggle expansion for a specific day
  void toggleExpansion(DayMealPlanEntity dayMealPlanEntity) {
    if (state.isExpanded && state.selectedDay == dayMealPlanEntity.day) {
      // If already expanded and same day, collapse
      collapseView();
    } else {
      // Expand new day
      selectDayMealPlan(dayMealPlanEntity);
    }
  }

  /// Collapse the expanded view and return to grid
  void collapseView() {
    state = state.copyWith(
      isExpanded: false,
      clearSelection: true,
    );
    logger.i('Collapsed meal plan view');
  }

  /// Check if a specific day is currently active
  bool isDayActive(String day) {
    return state.selectedDay == day && state.isExpanded;
  }

  /// Initialize with the first day's meal plan
  void initializeWithFirstDay(DayMealPlanEntity firstDay) {
    if (state.selectedMealPlan == null) {
      state = state.copyWith(
        selectedMealPlan: firstDay,
        selectedDay: firstDay.day,
        isExpanded: false,
      );
      logger.i('Initialized with first day: ${firstDay.day}');
    }
  }
}

final homepageStateProvider = NotifierProvider<HomepageNotifier, HomepageState>(
      () {
    return HomepageNotifier();
  },
);