import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository_interface.dart';

class GetConcreteNumberTrivia implements Usecase<NumberTrivia, Params> {
  final NumberTriviaRepositoryInterface repository;

  GetConcreteNumberTrivia({this.repository});

  @override
  Future<Either<Failure, NumberTrivia>> call({Params params}) async {
    return await repository.getConcreteNumberTrivia(number: params.number);
  }
}

class Params extends Equatable {
  final int number;

  Params({@required this.number});

  @override
  List<Object> get props => [number];
}
