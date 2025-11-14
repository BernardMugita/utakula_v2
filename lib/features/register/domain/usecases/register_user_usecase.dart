import 'package:dartz/dartz.dart';
import 'package:utakula_v2/core/error/failures.dart';
import 'package:utakula_v2/features/register/domain/entities/new_user.dart';
import 'package:utakula_v2/features/register/domain/repositories/sign_up_repository.dart';

class RegisterUserUseCase {
  final SignUpRepository repository;

  RegisterUserUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(
    NewUserEntity userEntity,
  ) async {
    return await repository.registerUser(userEntity);
  }
}
