import 'package:a_and_w/core/exceptions/failure.dart';
import 'package:a_and_w/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'test_helper.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late SignInWithEmailUseCase signInWithEmailUseCase;
  late MockUser mockUser;
  
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signInWithEmailUseCase = SignInWithEmailUseCase(mockAuthRepository);
    mockUser = MockUser();
  });

  group("signin with email usecase", () {
    const email = "test@example.com";
      const password = "password123";
    test("test singin berhasil dan mengembalikan uid serta email", () async {
      // Arrange
      
      
      when(mockUser.uid).thenReturn("uidnya");
      when(mockUser.email).thenReturn(email);
      
      when(mockAuthRepository.signInWithEmail(email, password))
          .thenAnswer((_) async => Right<Failure, User>(mockUser));

      // Act
      final result = await signInWithEmailUseCase.call(email, password);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return User, got failure: ${failure.message}'),
        (user) {
          expect(user.uid, "uidnya");
          expect(user.email, email);
        },
      );
      verify(mockAuthRepository.signInWithEmail(email, password)).called(1);
    });

    test("test email kosong mengembalikan failure", () async {
      // Arrange
      const emptyEmail = "";
      
      // Act
      final result = await signInWithEmailUseCase.call(emptyEmail, password);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Email wajib diisi'),
        (_) => fail('Should return failure'),
      );
      verifyNever(mockAuthRepository.signInWithEmail(any, any));
    });

    test("test password kosong mengembalikan failure", () async {
      // Arrange
      const emptyPassword = "";
      
      // Act
      final result = await signInWithEmailUseCase.call(email, emptyPassword);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Password wajib diisi'),
        (_) => fail('Should return failure'),
      );
      verifyNever(mockAuthRepository.signInWithEmail(any, any));
    });

    test("test format email tidak valid mengembalikan failure", () async {
      // Arrange
      const invalidEmail = "emailtidakvalid";
      
      // Act
      final result = await signInWithEmailUseCase.call(invalidEmail, password);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Format email tidak valid'),
        (_) => fail('Should return failure'),
      );
      verifyNever(mockAuthRepository.signInWithEmail(any, any));
    });

    test("test password kurang dari 6 karakter mengembalikan failure", () async {
      // Arrange
      const shortPassword = "12345";
      
      // Act
      final result = await signInWithEmailUseCase.call(email, shortPassword);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Password minimal 6 karakter'),
        (_) => fail('Should return failure'),
      );
      verifyNever(mockAuthRepository.signInWithEmail(any, any));
    });

    test("test repository mengembalikan failure", () async {
      // Arrange
      when(mockAuthRepository.signInWithEmail(email, password))
          .thenAnswer((_) async => const Left<Failure, User>(
                AuthFailure('Email atau password salah'),
              ));

      // Act
      final result = await signInWithEmailUseCase.call(email, password);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Email atau password salah'),
        (_) => fail('Should return failure'),
      );
      verify(mockAuthRepository.signInWithEmail(email, password)).called(1);
    });
    
  });
}
