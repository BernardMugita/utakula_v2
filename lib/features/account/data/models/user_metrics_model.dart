import 'package:utakula_v2/features/account/domain/entities/user_metrics_entity.dart';

class UserMetricsModel {
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

  UserMetricsModel({
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

  Map toJson() {
    return {
      "id": id,
      "user_id": userId,
      "gender": gender,
      "age": age,
      "weight_kg": weightKG,
      "height_cm": heightCM,
      "body_fat_percentage": bodyFatPercentage,
      "activity_level": activityLevel,
      "goal": goal,
      "calculated_tdee": calculatedTDEE,
      "is_current": isCurrent,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt,
    };
  }

  factory UserMetricsModel.fromJson(Map<String, dynamic> json) {
    return UserMetricsModel(
      id: json['id'],
      userId: json['user_id'],
      gender: json['gender'],
      age: json['age'],
      weightKG: json['weight_kg'],
      heightCM: json['height_cm'],
      bodyFatPercentage: json['body_fat_percentage'],
      activityLevel: json['activity_level'],
      goal: json['goal'],
      calculatedTDEE: json['calculated_tdee'],
      isCurrent: json['is_current'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  factory UserMetricsModel.fromEntity(UserMetricsEntity entity) {
    return UserMetricsModel(
      id: entity.id,
      userId: entity.userId,
      gender: entity.gender,
      age: entity.age,
      weightKG: entity.weightKG,
      heightCM: entity.heightCM,
      bodyFatPercentage: entity.bodyFatPercentage,
      activityLevel: entity.activityLevel,
      goal: entity.goal,
      calculatedTDEE: entity.calculatedTDEE,
      isCurrent: entity.isCurrent,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  UserMetricsEntity toEntity() {
    return UserMetricsEntity(
      id: id,
      userId: userId,
      gender: gender,
      age: age,
      weightKG: weightKG,
      heightCM: heightCM,
      bodyFatPercentage: bodyFatPercentage,
      activityLevel: activityLevel,
      goal: goal,
      calculatedTDEE: calculatedTDEE,
      isCurrent: isCurrent,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
