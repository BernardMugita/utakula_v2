import 'package:dartz/dartz.dart';
import 'package:utakula_v2/core/error/failures.dart';
import 'package:utakula_v2/features/account/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getUserAccountDetails();

  Future<Either<Failure, UserEntity>> updateUserAccountDetails(
    UserEntity userEntity,
  );
}
