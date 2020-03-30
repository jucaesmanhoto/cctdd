import 'dart:convert';

import 'package:cctdd/app/core/local_storage/custom_shared_preferences.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/exception.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSourceInterface {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia({NumberTriviaModel trivia});
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSource
    implements NumberTriviaLocalDataSourceInterface {
  final CustomSharedPreferences sharedPreferences;

  NumberTriviaLocalDataSource({@required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final String jsonString =
        (await sharedPreferences.prefs).getString(CACHED_NUMBER_TRIVIA);

    if (jsonString != null) {
      return Future.value(
          NumberTriviaModel.fromJson(jsonMap: jsonDecode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia({NumberTriviaModel trivia}) async {
    return (await sharedPreferences.prefs).setString(
        CACHED_NUMBER_TRIVIA,
        jsonEncode(
          trivia.toJson(),
        ));
  }
}
