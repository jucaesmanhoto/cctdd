import 'dart:convert';

import 'package:cctdd/app/core/error/exception.dart';
import 'package:cctdd/app/features/number_trivia/data/datasources/number_trivia_remote_data_source_interface.dart';
import 'package:cctdd/app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart' as matcher;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

main() {
  MockHttpClient mockHttpClient;
  NumberTriviaRemoteDataSource remoteDataSource;

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(fixture(filename: 'trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSource = NumberTriviaRemoteDataSource(client: mockHttpClient);
  });

  group('getConcreteTriva', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
        jsonMap: jsonDecode(fixture(filename: 'trivia.json')));
    test(
      '''should perforn a GET request on a URL with number being 
      the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        remoteDataSource.getConcreteNumberTrivia(number: tNumber);
        // assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/$tNumber',
          headers: {
            "Content-Type": "application/json",
          },
        ));
      },
    );

    test(
      'should return NumberTrivia when responseCode is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result =
            await remoteDataSource.getConcreteNumberTrivia(number: tNumber);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should throw ServerException when the statusCode is 404 or othen then 200',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = remoteDataSource.getConcreteNumberTrivia;
        // assert
        expect(() => call(number: tNumber),
            throwsA(matcher.TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomTriva', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
        jsonMap: jsonDecode(fixture(filename: 'trivia.json')));
    test(
      '''should perforn a GET request on a URL with number being 
      the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        remoteDataSource.getRandomNumberTrivia();
        // assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/random',
          headers: {
            "Content-Type": "application/json",
          },
        ));
      },
    );

    test(
      'should return NumberTrivia when responseCode is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await remoteDataSource.getRandomNumberTrivia();
        // assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should throw ServerException when the statusCode is 404 or othen then 200',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = remoteDataSource.getRandomNumberTrivia;
        // assert
        expect(() => call(), throwsA(matcher.TypeMatcher<ServerException>()));
      },
    );
  });
}
