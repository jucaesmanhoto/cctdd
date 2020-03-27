import 'dart:convert';

import 'package:cctdd/app/core/error/exception.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSourceInterface {
  Future<NumberTriviaModel> getConcreteNumberTrivia({int number});
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSource
    implements NumberTriviaRemoteDataSourceInterface {
  final http.Client client;

  NumberTriviaRemoteDataSource({@required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia({int number}) =>
      _getNumberTrivia(endpoint: number.toString());

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getNumberTrivia(endpoint: 'random');

  Future<NumberTriviaModel> _getNumberTrivia({String endpoint}) async {
    final response = await client.get(
      'http://numbersapi.com/$endpoint',
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(jsonMap: jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }
}
