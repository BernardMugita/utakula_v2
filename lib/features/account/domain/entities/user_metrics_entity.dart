class UserMetricsEntity {
  final String? id;
  final String? userId;
  final String? gender;
  final int? age;
  final double? weightKG;
  final double? heightCM;
  final double? bodyFatPercentage;
  final String? activityLevel;
  final String? goal;
  final double? calculatedTDEE;
  final bool? isCurrent;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserMetricsEntity({
    this.id,
    this.userId,
    this.gender,
    this.age,
    this.weightKG,
    this.heightCM,
    this.bodyFatPercentage,
    this.activityLevel,
    this.goal,
    this.calculatedTDEE,
    this.isCurrent,
    this.createdAt,
    this.updatedAt,
  });
}
