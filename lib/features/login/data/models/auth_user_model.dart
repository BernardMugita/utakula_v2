import '../../domain/entities/auth_user.dart';

class AuthUserModel {
  final String usernameOrEmail;
  final String password;

  const AuthUserModel({
    required this.usernameOrEmail,
    required this.password,
  });

  factory AuthUserModel.fromEntity(AuthUserEntity entity) {
    return AuthUserModel(
      usernameOrEmail: entity.usernameOrEmail,
      password: entity.password,
    );
  }

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      usernameOrEmail: json['username'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': usernameOrEmail,
      'password': password,
    };
  }

  AuthUserEntity toEntity() {
    return AuthUserEntity(
      usernameOrEmail: usernameOrEmail,
      password: password,
    );
  }
}