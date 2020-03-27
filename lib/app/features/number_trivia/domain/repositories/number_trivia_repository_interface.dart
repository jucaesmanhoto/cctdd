import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/number_trivia.dart';

abstract class NumberTriviaRepositoryInterface {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia({int number});
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
