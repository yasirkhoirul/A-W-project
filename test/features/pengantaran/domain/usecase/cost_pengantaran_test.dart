import 'package:a_and_w/core/exceptions/failure.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_cek_entity.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/cost_pengantaran.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_helper.mocks.dart';

void main() {
  late MockPengantaranRepository mockPengantaranRepository;
  late CostPengantaran usecase;

  setUp(() {
    mockPengantaranRepository = MockPengantaranRepository();
    usecase = CostPengantaran(mockPengantaranRepository);
  });

  final tDataCekRequestEntity = DataCekRequestEntity(
    origin: 501,
    destination: 114,
    weight: 1000,
    courier: 'jne',
  );

  const tDataCekEntityList = [
    DataCekEntity(
      name: 'JNE',
      code: 'jne',
      service: 'REG',
      description: 'Layanan Reguler',
      cost: 15000,
      etd: '2-3',
    ),
    DataCekEntity(
      name: 'JNE',
      code: 'jne',
      service: 'YES',
      description: 'Yakin Esok Sampai',
      cost: 25000,
      etd: '1-1',
    ),
  ];

  group('CostPengantaran', () {
    test(
      'should return list of DataCekEntity when call is successful',
      () async {
        // Arrange
        when(
          mockPengantaranRepository.getCekHarga(any),
        ).thenAnswer((_) async => const Right(tDataCekEntityList));

        // Act
        final result = await usecase(tDataCekRequestEntity);

        // Assert
        expect(result, const Right(tDataCekEntityList));
        verify(mockPengantaranRepository.getCekHarga(tDataCekRequestEntity));
        verifyNoMoreInteractions(mockPengantaranRepository);
      },
    );

    test('should return UnknownFailure when courier is empty', () async {
      // Arrange
      final invalidRequest = DataCekRequestEntity(
        origin: 501,
        destination: 114,
        weight: 1000,
        courier: '',
      );

      // Act
      final result = await usecase(invalidRequest);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<UnknownFailure>());
        expect(failure.message, 'Courier is required');
      }, (_) => fail('Should return Left'));
      verifyZeroInteractions(mockPengantaranRepository);
    });

    test('should return UnknownFailure when destination is 0', () async {
      // Arrange
      final invalidRequest = DataCekRequestEntity(
        origin: 501,
        destination: 0,
        weight: 1000,
        courier: 'jne',
      );

      // Act
      final result = await usecase(invalidRequest);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<UnknownFailure>());
        expect(failure.message, 'Destination is required');
      }, (_) => fail('Should return Left'));
      verifyZeroInteractions(mockPengantaranRepository);
    });

    test('should return UnknownFailure when origin is 0', () async {
      // Arrange
      final invalidRequest = DataCekRequestEntity(
        origin: 0,
        destination: 114,
        weight: 1000,
        courier: 'jne',
      );

      // Act
      final result = await usecase(invalidRequest);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<UnknownFailure>());
        expect(failure.message, 'Origin is required');
      }, (_) => fail('Should return Left'));
      verifyZeroInteractions(mockPengantaranRepository);
    });

    test('should return UnknownFailure when weight is 0', () async {
      // Arrange
      final invalidRequest = DataCekRequestEntity(
        origin: 501,
        destination: 114,
        weight: 0,
        courier: 'jne',
      );

      // Act
      final result = await usecase(invalidRequest);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<UnknownFailure>());
        expect(failure.message, 'Weight is required');
      }, (_) => fail('Should return Left'));
      verifyZeroInteractions(mockPengantaranRepository);
    });

    test('should return failure when repository returns failure', () async {
      // Arrange
      when(
        mockPengantaranRepository.getCekHarga(any),
      ).thenAnswer((_) async => const Left(NetworkFailure()));

      // Act
      final result = await usecase(tDataCekRequestEntity);

      // Assert
      expect(result, const Left(NetworkFailure()));
      verify(mockPengantaranRepository.getCekHarga(tDataCekRequestEntity));
    });

    test(
      'should return HttpApiFailure when repository returns HttpApiFailure',
      () async {
        // Arrange
        when(
          mockPengantaranRepository.getCekHarga(any),
        ).thenAnswer((_) async => const Left(HttpApiFailure('Server error')));

        // Act
        final result = await usecase(tDataCekRequestEntity);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<HttpApiFailure>());
          expect(failure.message, 'Server error');
        }, (_) => fail('Should return Left'));
        verify(mockPengantaranRepository.getCekHarga(tDataCekRequestEntity));
      },
    );
  });
}
