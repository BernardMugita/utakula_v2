class MealTypeFoodEntity {
  final String id;
  final String foodName;
  final String imageUrl;
  final int calories;

  MealTypeFoodEntity({
    required this.id,
    required this.foodName,
    required this.imageUrl,
    required this.calories,
  });
}

class SingleMealPlanEntity {
  final List<MealTypeFoodEntity> breakfast;
  final List<MealTypeFoodEntity> lunch;
  final List<MealTypeFoodEntity> supper;

  SingleMealPlanEntity({
    required this.breakfast,
    required this.lunch,
    required this.supper,
  });
}
