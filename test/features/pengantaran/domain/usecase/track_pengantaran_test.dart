import 'package:a_and_w/core/exceptions/failure.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_track_entity.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/track_pengantaran.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_helper.mocks.dart';

void main() {
  late MockPengantaranRepository mockPengantaranRepository;
  late TrackPengantaran usecase;

  setUp(() {
    mockPengantaranRepository = MockPengantaranRepository();
    usecase = TrackPengantaran(mockPengantaranRepository);
  });

  const tDataTrackRequestEntity = DataTrackRequestEntity(
    waybill: 'JNE123456789',
    courier: 'jne',
    lastPhoneNumber: 1234,
  );

  const tDataTrackEntityList = [
    DataTrackEntity(
      summary: DataTrackSummaryEntity(
        courierCode: 'jne',
        courierName: 'JNE',
        waybillNumber: 'JNE123456789',
        serviceCode: 'REG',
        waybillDate: '2026-02-08',
        shipperName: 'John Doe',
        receiverName: 'Jane Doe',
        origin: 'Jakarta',
        destination: 'Bandung',
        status: 'DELIVERED',
      ),
      manifest: [
        DataTrackManifestEntity(
          manifestCode: '1',
          manifestDescription: 'Paket diterima',
          manifestDate: '2026-02-08',
          manifestTime: '10:00',
          cityName: 'Bandung',
          title: 'Delivered',
        ),
      ],
    ),
  ];

  group('TrackPengantaran', () {
    test(
      'should return list of DataTrackEntity when call is successful',
      () async {
        // Arrange
        when(
          mockPengantaranRepository.getTrack(any),
        ).thenAnswer((_) async => const Right(tDataTrackEntityList));

        // Act
        final result = await usecase(tDataTrackRequestEntity);

        // Assert
        expect(result, const Right(tDataTrackEntityList));
        verify(mockPengantaranRepository.getTrack(tDataTrackRequestEntity));
        verifyNoMoreInteractions(mockPengantaranRepository);
      },
    );

    test('should return UnknownFailure when courier is empty', () async {
      // Arrange
      const invalidRequest = DataTrackRequestEntity(
        waybill: 'JNE123456789',
        courier: '',
        lastPhoneNumber: 1234,
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

    test('should return UnknownFailure when waybill is empty', () async {
      // Arrange
      const invalidRequest = DataTrackRequestEntity(
        waybill: '',
        courier: 'jne',
        lastPhoneNumber: 1234,
      );

      // Act
      final result = await usecase(invalidRequest);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<UnknownFailure>());
        expect(failure.message, 'Waybill is required');
      }, (_) => fail('Should return Left'));
      verifyZeroInteractions(mockPengantaranRepository);
    });

    test('should return UnknownFailure when lastPhoneNumber is 0', () async {
      // Arrange
      const invalidRequest = DataTrackRequestEntity(
        waybill: 'JNE123456789',
        courier: 'jne',
        lastPhoneNumber: 0,
      );

      // Act
      final result = await usecase(invalidRequest);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<UnknownFailure>());
        expect(failure.message, 'Last phone number is required');
      }, (_) => fail('Should return Left'));
      verifyZeroInteractions(mockPengantaranRepository);
    });

    test('should return failure when repository returns failure', () async {
      // Arrange
      when(
        mockPengantaranRepository.getTrack(any),
      ).thenAnswer((_) async => const Left(NetworkFailure()));

      // Act
      final result = await usecase(tDataTrackRequestEntity);

      // Assert
      expect(result, const Left(NetworkFailure()));
      verify(mockPengantaranRepository.getTrack(tDataTrackRequestEntity));
    });

    test(
      'should return HttpApiFailure when repository returns HttpApiFailure',
      () async {
        // Arrange
        when(mockPengantaranRepository.getTrack(any)).thenAnswer(
          (_) async => const Left(HttpApiFailure('Tracking not found')),
        );

        // Act
        final result = await usecase(tDataTrackRequestEntity);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<HttpApiFailure>());
          expect(failure.message, 'Tracking not found');
        }, (_) => fail('Should return Left'));
        verify(mockPengantaranRepository.getTrack(tDataTrackRequestEntity));
      },
    );
  });
}
