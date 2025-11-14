import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_sign_in_repository.dart';

class AuthorizeUser {
  final AuthSignInRepository repository;

  AuthorizeUser(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(
      AuthUserEntity userEntity,
      ) async {
    return await repository.authorizeUser(userEntity);
  }
}