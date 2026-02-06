import 'package:utakula_v2/features/register/domain/entities/google_user_entity.dart';

class GoogleSignUpModel {
  final String name;
  final String sub;
  final String email;
  final String token;

  const GoogleSignUpModel({
    required this.name,
    required this.sub,
    required this.email,
    required this.token,
  });

  factory GoogleSignUpModel.fromEntity(GoogleUserEntity entity) {
    return GoogleSignUpModel(
      name: entity.name,
      sub: entity.sub,
      email: entity.email,
      token: entity.token,
    );
  }

  factory GoogleSignUpModel.fromJson(Map<String, dynamic> json) {
    return GoogleSignUpModel(
      name: json['name'] as String,
      sub: json['sub'] as String,
      email: json['email'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'sub': sub, 'email': email, 'token': token};
  }

  GoogleUserEntity toEntity() {
    return GoogleUserEntity(name: name, sub: sub, email: email, token: token);
  }
}
