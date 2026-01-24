class UserMetricsEntity {
  final String id;
  final String userId;
  final String gender;
  final String age;
  final String weightKG;
  final String heightCM;
  final double bodyFatPercentage;
  final String activityLevel;
  final String goal;
  final double? calculatedTDEE;
  final bool isCurrent;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserMetricsEntity({
    required this.id,
    required this.userId,
    required this.gender,
    required this.age,
    required this.weightKG,
    required this.heightCM,
    required this.bodyFatPercentage,
    required this.activityLevel,
    required this.goal,
    required this.calculatedTDEE,
    required this.isCurrent,
    this.createdAt,
    this.updatedAt,
  });
}
