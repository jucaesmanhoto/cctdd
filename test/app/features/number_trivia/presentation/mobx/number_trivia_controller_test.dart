import 'package:cctdd/app/core/error/failure.dart';
import 'package:cctdd/app/core/error/error.dart';
import 'package:cctdd/app/core/util/constants.dart';
import 'package:cctdd/app/core/util/input_converter.dart';
import 'package:cctdd/app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:cctdd/app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:cctdd/app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:cctdd/app/features/number_trivia/presentation/mobx/number_trivia_controller.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

main() {
  NumberTriviaController triviaController;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    triviaController = NumberTriviaController(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test(
    'initial state should be empty',
    () async {
      expect(triviaController.triviaModel, null);
    },
  );

  group('getTriviaForConcreteNumber', () {
    final tStringNumber = '1';
    final tParsedInt = 1;
    final tTriviaModel = NumberTriviaModel(number: 1, text: 'test trivia');
    test(
      'should call the inputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(
                string: anyNamed('string')))
            .thenReturn(Right(tParsedInt));
        when(mockGetConcreteNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Right(tTriviaModel));
        // act
        triviaController.getTriviaForConcreteNumber(string: tStringNumber);
        // assert
        verify(
            mockInputConverter.stringToUnsignedInteger(string: tStringNumber));
      },
    );

    test(
      'should emit Error when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(
                string: anyNamed('string')))
            .thenReturn(Left(InvalidInputFailure()));
        // act
        await triviaController.getTriviaForConcreteNumber(
            string: tStringNumber);
        // assert
        final expected = Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        expect(triviaController.error, expected);
      },
    );

    test(
      'should get data from concrete use case',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(
                string: anyNamed('string')))
            .thenReturn(Right(tParsedInt));
        when(mockGetConcreteNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Right(tTriviaModel));
        // act
        await triviaController.getTriviaForConcreteNumber(
            string: tStringNumber);
        // assert
        verify(mockGetConcreteNumberTrivia(params: Params(number: tParsedInt)));
      },
    );

    test(
      'should starts loading and then get the data sucessfully',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(
                string: anyNamed('string')))
            .thenReturn(Right(tParsedInt));
        when(mockGetConcreteNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Right(tTriviaModel));
        // act
        expect(triviaController.isLoading, false);
        await triviaController.getTriviaForConcreteNumber(
            string: tStringNumber);
        await untilCalled(
            mockGetConcreteNumberTrivia(params: anyNamed('params')));
        // assert
        expect(triviaController.triviaModel, tTriviaModel);
      },
    );

    test(
      'should emit an Error when getting data fails',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(
                string: anyNamed('string')))
            .thenReturn(Right(tParsedInt));
        when(mockGetConcreteNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Left(ServerFailure()));
        // act
        await triviaController.getTriviaForConcreteNumber(
            string: tStringNumber);
        // assert
        final expected = Error(message: SERVER_FAILURE_MESSAGE);
        expect(triviaController.error, expected);
      },
    );

    test(
      'should emit an Error with the proper message when getting data fails',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(
                string: anyNamed('string')))
            .thenReturn(Right(tParsedInt));
        when(mockGetConcreteNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Left(CacheFailure()));
        // act
        await triviaController.getTriviaForConcreteNumber(
            string: tStringNumber);
        // assert
        final expected = Error(message: CACHE_FAILURE_MESSAGE);
        expect(triviaController.error, expected);
      },
    );
  });

  group('getTriviaForRandomNumber', () {
    final tTriviaModel = NumberTriviaModel(number: 1, text: 'test trivia');

    test(
      'should get data from Random use case',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Right(tTriviaModel));
        // act
        await triviaController.getTriviaForRandomNumber();
        // assert
        verify(mockGetRandomNumberTrivia(params: anyNamed('params')));
      },
    );

    test(
      'should starts loading and then get the data sucessfully',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Right(tTriviaModel));
        // act
        expect(triviaController.isLoading, false);
        await triviaController.getTriviaForRandomNumber();
        await untilCalled(
            mockGetRandomNumberTrivia(params: anyNamed('params')));
        // assert
        expect(triviaController.triviaModel, tTriviaModel);
      },
    );

    test(
      'should emit an Error when getting data fails',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Left(ServerFailure()));
        // act
        await triviaController.getTriviaForRandomNumber();
        // assert
        final expected = Error(message: SERVER_FAILURE_MESSAGE);
        expect(triviaController.error, expected);
      },
    );

    test(
      'should emit an Error with the proper message when getting data fails',
      () async {
        // arrangeßt
        when(mockGetRandomNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Left(CacheFailure()));
        // act
        await triviaController.getTriviaForRandomNumber();
        // assert
        final expected = Error(message: CACHE_FAILURE_MESSAGE);
        expect(triviaController.error, expected);
      },
    );
  });
}
