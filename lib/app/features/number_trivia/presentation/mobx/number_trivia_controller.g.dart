// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'number_trivia_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$NumberTriviaController on _NumberTriviaControllerBase, Store {
  final _$triviaModelAtom =
      Atom(name: '_NumberTriviaControllerBase.triviaModel');

  @override
  NumberTriviaModel get triviaModel {
    _$triviaModelAtom.context.enforceReadPolicy(_$triviaModelAtom);
    _$triviaModelAtom.reportObserved();
    return super.triviaModel;
  }

  @override
  set triviaModel(NumberTriviaModel value) {
    _$triviaModelAtom.context.conditionallyRunInAction(() {
      super.triviaModel = value;
      _$triviaModelAtom.reportChanged();
    }, _$triviaModelAtom, name: '${_$triviaModelAtom.name}_set');
  }

  final _$errorAtom = Atom(name: '_NumberTriviaControllerBase.error');

  @override
  Error get error {
    _$errorAtom.context.enforceReadPolicy(_$errorAtom);
    _$errorAtom.reportObserved();
    return super.error;
  }

  @override
  set error(Error value) {
    _$errorAtom.context.conditionallyRunInAction(() {
      super.error = value;
      _$errorAtom.reportChanged();
    }, _$errorAtom, name: '${_$errorAtom.name}_set');
  }

  final _$isLoadingAtom = Atom(name: '_NumberTriviaControllerBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.context.enforceReadPolicy(_$isLoadingAtom);
    _$isLoadingAtom.reportObserved();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.context.conditionallyRunInAction(() {
      super.isLoading = value;
      _$isLoadingAtom.reportChanged();
    }, _$isLoadingAtom, name: '${_$isLoadingAtom.name}_set');
  }

  final _$getTriviaForConcreteNumberAsyncAction =
      AsyncAction('getTriviaForConcreteNumber');

  @override
  Future<void> getTriviaForConcreteNumber({String string}) {
    return _$getTriviaForConcreteNumberAsyncAction
        .run(() => super.getTriviaForConcreteNumber(string: string));
  }

  @override
  String toString() {
    final string =
        'triviaModel: ${triviaModel.toString()},error: ${error.toString()},isLoading: ${isLoading.toString()}';
    return '{$string}';
  }
}
