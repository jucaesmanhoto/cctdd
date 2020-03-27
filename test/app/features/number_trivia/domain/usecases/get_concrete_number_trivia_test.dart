import 'package:cctdd/app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cctdd/app/features/number_trivia/domain/repositories/number_trivia_repository_interface.dart';
import 'package:cctdd/app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepositoryInterface {}

main() {
  MockNumberTriviaRepository mockNumberTriviaRepository;
  GetConcreteNumberTrivia usecase;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(repository: mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(number: 1, text: 'test');
  test(
    'should get the trivia for the number from the repository',
    () async {
      // arrange
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(
              number: anyNamed("number")))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      final result = await usecase(params: Params(number: tNumber));
      // assert
      expect(result, Right(tNumberTrivia));
      verify(
          mockNumberTriviaRepository.getConcreteNumberTrivia(number: tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
