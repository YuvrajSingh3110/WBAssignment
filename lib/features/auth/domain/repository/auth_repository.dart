import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/common/entities/user.dart';
import 'package:task_app/core/error/failures.dart';

abstract interface class AuthRepository {
  //we are in domain layer and should not access data from data layer,that is why we are return User (domain layer)
  // and not UserModel which is in data layer
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> currentUser();
}
