import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository_interface.dart';

class GetRandomNumberTrivia extends Usecase<NumberTrivia, NoParams> {
  final NumberTriviaRepositoryInterface repository;

  GetRandomNumberTrivia({this.repository});

  @override
  Future<Either<Failure, NumberTrivia>> call({NoParams params}) async {
    return await repository.getRandomNumberTrivia();
  }
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
