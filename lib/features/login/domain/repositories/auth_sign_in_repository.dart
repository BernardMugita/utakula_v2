import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_user.dart';

abstract class AuthSignInRepository {
  Future<Either<Failure, Map<String, dynamic>>> authorizeUser(
      AuthUserEntity userEntity,
      );
}