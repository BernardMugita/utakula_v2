import 'package:utakula_v2/features/reminders/domain/entities/notification_entity.dart';

class NotificationModel {
  final String meal;

  NotificationModel({required this.meal});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(meal: json['meal'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'meal': meal};
  }

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(meal: entity.meal);
  }

  NotificationEntity toEntity() {
    return NotificationEntity(meal: meal);
  }
}

final notificationModel = NotificationModel(meal: 'breakfast');
