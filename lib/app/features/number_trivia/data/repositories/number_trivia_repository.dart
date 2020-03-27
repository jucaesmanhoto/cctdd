import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository_interface.dart';
import '../datasources/number_trivia_local_data_source_interface.dart';
import '../datasources/number_trivia_remote_data_source_interface.dart';

typedef Future<NumberTrivia> _ConcreteOrRandomChooser();

class NumberTriviaRepository implements NumberTriviaRepositoryInterface {
  final NetworkInfoInterface networkInfo;
  final NumberTriviaRemoteDataSourceInterface remoteDataSource;
  final NumberTriviaLocalDataSourceInterface localDataSource;

  NumberTriviaRepository({
    @required this.networkInfo,
    @required this.remoteDataSource,
    @required this.localDataSource,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      {int number}) async {
    return _getTrivia(
        () => remoteDataSource.getConcreteNumberTrivia(number: number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        await localDataSource.cacheNumberTrivia(trivia: remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
