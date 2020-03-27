import 'package:cctdd/app/core/error/exception.dart';
import 'package:cctdd/app/core/error/failure.dart';
import 'package:cctdd/app/core/network/network_info.dart';
import 'package:cctdd/app/features/number_trivia/data/datasources/number_trivia_local_data_source_interface.dart';
import 'package:cctdd/app/features/number_trivia/data/datasources/number_trivia_remote_data_source_interface.dart';
import 'package:cctdd/app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:cctdd/app/features/number_trivia/data/repositories/number_trivia_repository.dart';
import 'package:cctdd/app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSourceInterface {}

class MockLocalDataSource extends Mock
    implements NumberTriviaLocalDataSourceInterface {}

class MockNetworkInfo extends Mock implements NetworkInfoInterface {}

main() {
  NumberTriviaRepository repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repository = NumberTriviaRepository(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getConcreteNumberTrivia', () {
    final int tNumber = 1;
    final NumberTriviaModel tNumberTriviaModel = NumberTriviaModel(
      number: tNumber,
      text: 'test text',
    );
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getConcreteNumberTrivia(number: tNumber);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    void runTestsOnline(Function body) {
      group('device is online', () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        });
        body();
      });
    }

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(
                  number: anyNamed("number")))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result =
              await repository.getConcreteNumberTrivia(number: tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(number: tNumber));
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data localy when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(
                  number: anyNamed("number")))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repository.getConcreteNumberTrivia(number: tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(number: tNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(
              trivia: tNumberTriviaModel));
        },
      );

      test(
        'should return server error when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(
                  number: anyNamed("number")))
              .thenThrow(ServerException());
          // act
          final result =
              await repository.getConcreteNumberTrivia(number: tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(number: tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    void runTestsOffline(Function body) {
      group('device is offline', () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        });
        body();
      });
    }

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result =
              await repository.getConcreteNumberTrivia(number: tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        'should return CacheFailure when there is no cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final result =
              await repository.getConcreteNumberTrivia(number: tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    final NumberTriviaModel tNumberTriviaModel = NumberTriviaModel(
      number: 123,
      text: 'test text',
    );
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getRandomNumberTrivia();
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    void runTestsOnline(Function body) {
      group('device is online', () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        });
        body();
      });
    }

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data localy when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(
              trivia: tNumberTriviaModel));
        },
      );

      test(
        'should return server error when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    void runTestsOffline(Function body) {
      group('device is offline', () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        });
        body();
      });
    }

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        'should return CacheFailure when there is no cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });
}
