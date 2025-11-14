import 'package:utakula_v2/features/register/domain/entities/new_user.dart';

class NewUserModel {
  final String username;
  final String email;
  final String password;

  const NewUserModel({
    required this.username,
    required this.email,
    required this.password,
  });

  factory NewUserModel.fromEntity(NewUserEntity entity) {
    return NewUserModel(
      username: entity.username,
      email: entity.email,
      password: entity.password,
    );
  }

  factory NewUserModel.fromJson(Map<String, dynamic> json) {
    return NewUserModel(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'email': email, 'password': password};
  }

  NewUserEntity toEntity() {
    return NewUserEntity(username: username, email: email, password: password);
  }
}
