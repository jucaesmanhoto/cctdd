import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/user_entity.dart';

abstract class LoginRepositoryInterface {
  Future<Either<Failure, UserEntity>> signIn({String email, String password});
  Future<Either<Failure, UserEntity>> autoSignIn();
  Future<Either<Failure, UserEntity>> signOut();
}
