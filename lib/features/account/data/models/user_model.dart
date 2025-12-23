import 'package:utakula_v2/features/account/domain/entities/user_entity.dart';

class UserModel {
  final String? id;
  final String? username;
  final String? role;
  final String? email;
  final String? deviceToken;

  const UserModel({
    required this.id,
    required this.username,
    required this.role,
    required this.email,
    required this.deviceToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      role: json['role'] as String,
      email: json['email'] as String,
      deviceToken: json['device_token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'role': role,
      'email': email,
      'device_token': deviceToken,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      username: entity.username,
      role: entity.role,
      email: entity.email,
      deviceToken: entity.deviceToken,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: username,
      role: role,
      email: email,
      deviceToken: deviceToken,
    );
  }
}
