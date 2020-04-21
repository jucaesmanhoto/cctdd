import 'package:cctdd/app/core/error/failure.dart';
import 'package:cctdd/app/core/util/constants.dart';
import 'package:cctdd/app/core/util/input_converter.dart';
import 'package:cctdd/app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:cctdd/app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cctdd/app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:cctdd/app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import '../../../../core/error/error.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';

part 'number_trivia_controller.g.dart';

class NumberTriviaController = _NumberTriviaControllerBase
    with _$NumberTriviaController;

abstract class _NumberTriviaControllerBase with Store {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  _NumberTriviaControllerBase({
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random;

  @observable
  NumberTriviaModel triviaModel;

  @observable
  Error error;

  @observable
  bool isLoading = false;

  @action
  Future<void> getTriviaForConcreteNumber({String string}) async {
    print('cheguei');
    isLoading = true;
    final inputEither = inputConverter.stringToUnsignedInteger(string: string);
    print(1);
    inputEither.fold((failure) {
      triviaModel = null;
      error = Error(message: INVALID_INPUT_FAILURE_MESSAGE);
      print(2);
    }, (integer) async {
      final responseEither =
          await getConcreteNumberTrivia(params: Params(number: integer));
      _eitherFailureOrTrivia(responseEither);
      error = null;
      print(3);
    });
    isLoading = false;
  }

  void _eitherFailureOrTrivia(Either<Failure, NumberTrivia> responseEither) {
    responseEither.fold((failure) {
      triviaModel = null;
      error = Error(message: _mapFailureToString(failure: failure));
    }, (trivia) {
      triviaModel = trivia;
      error = null;
    });
  }

  Future<void> getTriviaForRandomNumber() async {
    isLoading = true;
    final responseEither = await getRandomNumberTrivia();
    _eitherFailureOrTrivia(responseEither);
    error = null;
    isLoading = false;
  }

  String _mapFailureToString({Failure failure}) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unsxpected Error';
    }
  }
}
