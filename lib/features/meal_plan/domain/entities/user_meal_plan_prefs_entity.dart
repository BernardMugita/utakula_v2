class UserMealPlanPrefsEntity {
  final String bodyGoal;
  final List<String> dietaryRestrictions;
  final List<String> allergies;
  final int dailyCalorieTarget;
  final List<String> medicalConditions;

  const UserMealPlanPrefsEntity({
    required this.bodyGoal,
    required this.dietaryRestrictions,
    required this.allergies,
    required this.dailyCalorieTarget,
    required this.medicalConditions,
  });
}
