import 'dart:convert';

import 'package:cctdd/app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:cctdd/app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test text');

  test(
    'should be a subclass of NumberTriviaEntity',
    () async {
      // assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when JSON String is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            jsonDecode(fixture(filename: 'trivia.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap: jsonMap);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should return a valid model when JSON String is regarded as a double',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            jsonDecode(fixture(filename: 'trivia_double.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap: jsonMap);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a Json map containing the proper data',
      () async {
        // act
        final result = tNumberTriviaModel.toJson();
        final expectedMap = {"number": 1, "text": 'test text'};
        // assert
        expect(result, expectedMap);
      },
    );
  });
}
