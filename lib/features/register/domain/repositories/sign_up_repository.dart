import 'package:dartz/dartz.dart';
import 'package:utakula_v2/core/error/failures.dart';
import 'package:utakula_v2/features/register/domain/entities/new_user.dart';

abstract class SignUpRepository {
  Future<Either<Failure, Map<String, dynamic>>> registerUser(
    NewUserEntity userEntity,
  );
}
