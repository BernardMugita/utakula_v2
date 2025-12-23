import 'package:dartz/dartz.dart';
import 'package:utakula_v2/core/error/failures.dart';
import 'package:utakula_v2/features/account/domain/entities/user_entity.dart';
import 'package:utakula_v2/features/account/domain/repositories/user_repository.dart';

class GetUserAccountDetails {
  final UserRepository repository;

  GetUserAccountDetails(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getUserAccountDetails();
  }
}

class UpdateUserAccountDetails {
  final UserRepository repository;

  UpdateUserAccountDetails(this.repository);

  Future<Either<Failure, UserEntity>> call(UserEntity userEntity) async {
    return await repository.updateUserAccountDetails(userEntity);
  }
}
