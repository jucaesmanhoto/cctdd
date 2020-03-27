import 'package:meta/meta.dart';

import '../../domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({
    @required number,
    @required text,
  }) : super(number: number, text: text);

  factory NumberTriviaModel.fromJson({Map<String, dynamic> jsonMap}) {
    return NumberTriviaModel(
      number: (jsonMap['number'] as num).toInt(),
      text: jsonMap['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "number": number,
      "text": text,
    };
  }
}
