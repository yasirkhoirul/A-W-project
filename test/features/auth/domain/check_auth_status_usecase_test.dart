

import 'package:a_and_w/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'test_helper.mocks.dart';

void main(){
  late MockAuthRepository mockAuthRepository;
  late CheckAuthStatusUseCase checkAuthStatusUseCase;
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    checkAuthStatusUseCase = CheckAuthStatusUseCase(mockAuthRepository);
  });
  
  group("check auth test", () {
    test("return false jika status auth false", () {
      when(mockAuthRepository.checkStatusAuth())
        .thenAnswer((_) => Stream.value(false),);
      final result = checkAuthStatusUseCase();
      expectLater(result, emitsInOrder([false]),);
    },);
    test("return true jika status auth true", () {
      when(mockAuthRepository.checkStatusAuth())
        .thenAnswer((_) => Stream.value(true),);
      final result = checkAuthStatusUseCase();
      expectLater(result, emitsInOrder([true]),);
    },);
  },);
}