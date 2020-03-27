import 'package:cctdd/app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cctdd/app/features/number_trivia/domain/repositories/number_trivia_repository_interface.dart';
import 'package:cctdd/app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepositoryInterface {}

main() {
  MockNumberTriviaRepository mockNumberTriviaRepository;
  GetRandomNumberTrivia usecase;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(repository: mockNumberTriviaRepository);
  });

  final tNumberTrivia = NumberTrivia(number: 1, text: 'test');
  test(
    'should get the trivia from the random repository',
    () async {
      // arrange
      when(mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      final result = await usecase();
      // assert
      expect(result, Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
