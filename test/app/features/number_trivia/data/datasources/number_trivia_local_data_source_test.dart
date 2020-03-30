import 'dart:convert';

import 'package:cctdd/app/core/error/exception.dart';
import 'package:cctdd/app/core/local_storage/custom_shared_preferences.dart';
import 'package:cctdd/app/features/number_trivia/data/datasources/number_trivia_local_data_source_interface.dart';
import 'package:cctdd/app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart' as matcher;

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements CustomSharedPreferences {}

void main() {
  NumberTriviaLocalDataSource dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource =
        NumberTriviaLocalDataSource(sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
        jsonMap: jsonDecode(fixture(filename: 'trivia_cached.json')));

    test(
      'should return NumberTrivia from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        final prefs = await mockSharedPreferences.prefs;
        when(prefs.getString(any))
            .thenReturn(fixture(filename: 'trivia_cached.json'));
        // act
        final result = await dataSource.getLastNumberTrivia();
        // assert
        verify(prefs.getString('CACHED_NUMBER_TRIVIA'));
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should throw a CacheException when there is not a cached value',
      () async {
        // arrange
        final prefs = await mockSharedPreferences.prefs;
        when(prefs.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getLastNumberTrivia;
        // assert
        expect(() => call(), throwsA(matcher.TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test text');
    test(
      'should call SharedPreferences to cache the data',
      () async {
        // act
        final prefs = await mockSharedPreferences.prefs;
        dataSource.cacheNumberTrivia(trivia: tNumberTriviaModel);
        // assert
        final expectedJsonString = jsonEncode(tNumberTriviaModel.toJson());

        verify(prefs.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
      },
    );
  });
}
