import 'package:a_and_w/core/exceptions/failure.dart';
import 'package:a_and_w/core/exceptions/http_api_exception.dart';
import 'package:a_and_w/features/pengantaran/data/datasource/pengantaran_remote_datasource.dart';
import 'package:a_and_w/features/pengantaran/data/model/distrik_response.dart';
import 'package:a_and_w/features/pengantaran/data/model/kota_response.dart';
import 'package:a_and_w/features/pengantaran/data/model/provinsi_response.dart';
import 'package:a_and_w/features/pengantaran/data/repository_implementation/pengantaran_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'pengantaran_repository_test.mocks.dart';

@GenerateMocks([PengantaranRemoteDatasource])
void main() {
  late MockPengantaranRemoteDatasource mockRemoteDatasource;
  late PengantaranRepositoryImpl repository;

  setUp(() {
    mockRemoteDatasource = MockPengantaranRemoteDatasource();
    repository = PengantaranRepositoryImpl(mockRemoteDatasource);
  });

  group('getProvinsi', () {
    const List<ProvinsiModel> tProvinsiList = [
      ProvinsiModel(id: 1, name: 'DKI Jakarta'),
      ProvinsiModel(id: 2, name: 'Jawa Barat'),
    ];

    const tProvinsiResponse = ProvinsiResponse(
      meta: Meta(message: 'Success', code: 200, status: 'success'),
      data: tProvinsiList,
    );

    test(
      'should return list of ProvinsiModel when call is successful',
      () async {
        // Arrange
        when(
          mockRemoteDatasource.getProvinsi(),
        ).thenAnswer((_) async => tProvinsiResponse);

        // Act
        final result = await repository.getProvinsi();

        // Assert
        expect(result, equals(const Right(tProvinsiList)));
        verify(mockRemoteDatasource.getProvinsi());
        verifyNoMoreInteractions(mockRemoteDatasource);
      },
    );

    test('should return UnknownFailure when data is null', () async {
      // Arrange
      const tEmptyResponse = ProvinsiResponse(
        meta: Meta(message: 'Success', code: 200, status: 'success'),
        data: null,
      );
      when(
        mockRemoteDatasource.getProvinsi(),
      ).thenAnswer((_) async => tEmptyResponse);

      // Act
      final result = await repository.getProvinsi();

      // Assert
      expect(
        result,
        equals(const Left(UnknownFailure('Exception: Data provinsi kosong'))),
      );
      verify(mockRemoteDatasource.getProvinsi());
    });

    test('should return UnknownFailure when data is empty', () async {
      // Arrange
      const tEmptyResponse = ProvinsiResponse(
        meta: Meta(message: 'Success', code: 200, status: 'success'),
        data: [],
      );
      when(
        mockRemoteDatasource.getProvinsi(),
      ).thenAnswer((_) async => tEmptyResponse);

      // Act
      final result = await repository.getProvinsi();

      // Assert
      expect(
        result,
        equals(const Left(UnknownFailure('Exception: Data provinsi kosong'))),
      );
      verify(mockRemoteDatasource.getProvinsi());
    });

    test(
      'should return NetworkFailure when HttpNetworkException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDatasource.getProvinsi(),
        ).thenThrow(const HttpNetworkException('Tidak ada koneksi internet'));

        // Act
        final result = await repository.getProvinsi();

        // Assert
        expect(result, equals(const Left(NetworkFailure())));
        expect(
          result.fold((failure) => failure.message, (_) => ''),
          'Tidak ada koneksi internet',
        );
        verify(mockRemoteDatasource.getProvinsi());
      },
    );

    test(
      'should return HttpApiFailure when HttpApiException is thrown',
      () async {
        // Arrange
        const tException = HttpApiException(
          'Unauthorized: Kunci API tidak valid',
        );
        when(mockRemoteDatasource.getProvinsi()).thenThrow(tException);

        // Act
        final result = await repository.getProvinsi();

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<HttpApiFailure>());
          expect(failure.message, 'Unauthorized: Kunci API tidak valid');
        }, (_) => fail('Should return Left'));
        verify(mockRemoteDatasource.getProvinsi());
      },
    );

    test(
      'should return UnknownFailure when unknown exception is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDatasource.getProvinsi(),
        ).thenThrow(Exception('Unknown error'));

        // Act
        final result = await repository.getProvinsi();

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<UnknownFailure>());
          expect(failure.message, contains('Unknown error'));
        }, (_) => fail('Should return Left'));
        verify(mockRemoteDatasource.getProvinsi());
      },
    );
  });

  group('getKota', () {
    const tProvinsiId = '2';
    const List<KotaModel> tKotaList = [
      KotaModel(id: 11, name: 'AMBON'),
      KotaModel(id: 12, name: 'BANDUNG'),
    ];

    const tKotaResponse = KotaResponse(
      meta: Meta(message: 'Success', code: 200, status: 'success'),
      data: tKotaList,
    );

    test('should return list of KotaModel when call is successful', () async {
      // Arrange
      when(
        mockRemoteDatasource.getKota(tProvinsiId),
      ).thenAnswer((_) async => tKotaResponse);

      // Act
      final result = await repository.getKota(tProvinsiId);

      // Assert
      expect(result, equals(const Right(tKotaList)));
      verify(mockRemoteDatasource.getKota(tProvinsiId));
      verifyNoMoreInteractions(mockRemoteDatasource);
    });

    test('should return UnknownFailure when data is null', () async {
      // Arrange
      const tEmptyResponse = KotaResponse(
        meta: Meta(message: 'Success', code: 200, status: 'success'),
        data: null,
      );
      when(
        mockRemoteDatasource.getKota(tProvinsiId),
      ).thenAnswer((_) async => tEmptyResponse);

      // Act
      final result = await repository.getKota(tProvinsiId);

      // Assert
      expect(result, equals(const Left(UnknownFailure('Exception: Data kota kosong'))));
      verify(mockRemoteDatasource.getKota(tProvinsiId));
    });

    test('should return UnknownFailure when data is empty', () async {
      // Arrange
      const tEmptyResponse = KotaResponse(
        meta: Meta(message: 'Success', code: 200, status: 'success'),
        data: [],
      );
      when(
        mockRemoteDatasource.getKota(tProvinsiId),
      ).thenAnswer((_) async => tEmptyResponse);

      // Act
      final result = await repository.getKota(tProvinsiId);

      // Assert
      expect(result, equals(const Left(UnknownFailure('Exception: Data kota kosong'))));
      verify(mockRemoteDatasource.getKota(tProvinsiId));
    });

    test(
      'should return NetworkFailure when HttpNetworkException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDatasource.getKota(tProvinsiId),
        ).thenThrow(const HttpNetworkException('Tidak ada koneksi internet'));

        // Act
        final result = await repository.getKota(tProvinsiId);

        // Assert
        expect(result, equals(const Left(NetworkFailure())));
        expect(
          result.fold((failure) => failure.message, (_) => ''),
          'Tidak ada koneksi internet',
        );
        verify(mockRemoteDatasource.getKota(tProvinsiId));
      },
    );

    test(
      'should return HttpApiFailure when HttpApiException is thrown',
      () async {
        // Arrange
        const tException = HttpApiException(
          'Not Found: Sumber daya tidak ditemukan',
        );
        when(mockRemoteDatasource.getKota(tProvinsiId)).thenThrow(tException);

        // Act
        final result = await repository.getKota(tProvinsiId);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<HttpApiFailure>());
          expect(failure.message, 'Not Found: Sumber daya tidak ditemukan');
        }, (_) => fail('Should return Left'));
        verify(mockRemoteDatasource.getKota(tProvinsiId));
      },
    );

    test(
      'should return UnknownFailure when unknown exception is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDatasource.getKota(tProvinsiId),
        ).thenThrow(Exception('Unknown error'));

        // Act
        final result = await repository.getKota(tProvinsiId);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<UnknownFailure>());
          expect(failure.message, contains('Unknown error'));
        }, (_) => fail('Should return Left'));
        verify(mockRemoteDatasource.getKota(tProvinsiId));
      },
    );
  });

  group('getDistrik', () {
    const tKotaId = '123';
    const List<DistrikModel> tDistrikList = [
      DistrikModel(id: 5816, name: 'PURBALINGGA'),
      DistrikModel(id: 5876, name: 'BOJONGSARI'),
    ];

    const tDistrikResponse = DistrikResponse(
      meta: Meta(message: 'Success', code: 200, status: 'success'),
      data: tDistrikList,
    );

    test(
      'should return list of DistrikModel when call is successful',
      () async {
        // Arrange
        when(
          mockRemoteDatasource.getDistrik(tKotaId),
        ).thenAnswer((_) async => tDistrikResponse);

        // Act
        final result = await repository.getDistrik(tKotaId);

        // Assert
        expect(result, equals(const Right(tDistrikList)));
        verify(mockRemoteDatasource.getDistrik(tKotaId));
        verifyNoMoreInteractions(mockRemoteDatasource);
      },
    );

    test('should return UnknownFailure when data is null', () async {
      // Arrange
      const tEmptyResponse = DistrikResponse(
        meta: Meta(message: 'Success', code: 200, status: 'success'),
        data: null,
      );
      when(
        mockRemoteDatasource.getDistrik(tKotaId),
      ).thenAnswer((_) async => tEmptyResponse);

      // Act
      final result = await repository.getDistrik(tKotaId);

      // Assert
      expect(result, equals(const Left(UnknownFailure('Exception: Data distrik kosong'))));
      verify(mockRemoteDatasource.getDistrik(tKotaId));
    });

    test('should return UnknownFailure when data is empty', () async {
      // Arrange
      const tEmptyResponse = DistrikResponse(
        meta: Meta(message: 'Success', code: 200, status: 'success'),
        data: [],
      );
      when(
        mockRemoteDatasource.getDistrik(tKotaId),
      ).thenAnswer((_) async => tEmptyResponse);

      // Act
      final result = await repository.getDistrik(tKotaId);

      // Assert
      expect(result, equals(const Left(UnknownFailure('Exception: Data distrik kosong'))));
      verify(mockRemoteDatasource.getDistrik(tKotaId));
    });

    test(
      'should return NetworkFailure when HttpNetworkException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDatasource.getDistrik(tKotaId),
        ).thenThrow(const HttpNetworkException('Tidak ada koneksi internet'));

        // Act
        final result = await repository.getDistrik(tKotaId);

        // Assert
        expect(result, equals(const Left(NetworkFailure())));
        expect(
          result.fold((failure) => failure.message, (_) => ''),
          'Tidak ada koneksi internet',
        );
        verify(mockRemoteDatasource.getDistrik(tKotaId));
      },
    );

    test(
      'should return HttpApiFailure when HttpApiException is thrown',
      () async {
        // Arrange
        const tException = HttpApiException(
          'Bad Request: Permintaan tidak valid',
        );
        when(mockRemoteDatasource.getDistrik(tKotaId)).thenThrow(tException);

        // Act
        final result = await repository.getDistrik(tKotaId);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<HttpApiFailure>());
          expect(failure.message, 'Bad Request: Permintaan tidak valid');
        }, (_) => fail('Should return Left'));
        verify(mockRemoteDatasource.getDistrik(tKotaId));
      },
    );

    test(
      'should return DatabaseFailure when HttpApiException with Server error is thrown',
      () async {
        // Arrange
        const tException = HttpApiException(
          'Internal Server Error: Kesalahan pada server',
        );
        when(mockRemoteDatasource.getDistrik(tKotaId)).thenThrow(tException);

        // Act
        final result = await repository.getDistrik(tKotaId);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<DatabaseFailure>());
          expect(
            failure.message,
            'Internal Server Error: Kesalahan pada server',
          );
        }, (_) => fail('Should return Left'));
        verify(mockRemoteDatasource.getDistrik(tKotaId));
      },
    );

    test(
      'should return HttpApiFailure when HttpUnknownException is thrown',
      () async {
        // Arrange
        const tException = HttpUnknownException(
          'Terjadi kesalahan yang tidak diketahui',
        );
        when(mockRemoteDatasource.getDistrik(tKotaId)).thenThrow(tException);

        // Act
        final result = await repository.getDistrik(tKotaId);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<HttpApiFailure>());
          expect(failure.message, 'Terjadi kesalahan yang tidak diketahui');
        }, (_) => fail('Should return Left'));
        verify(mockRemoteDatasource.getDistrik(tKotaId));
      },
    );

    test(
      'should return UnknownFailure when unknown exception is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDatasource.getDistrik(tKotaId),
        ).thenThrow(Exception('Unknown error'));

        // Act
        final result = await repository.getDistrik(tKotaId);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<UnknownFailure>());
          expect(failure.message, contains('Unknown error'));
        }, (_) => fail('Should return Left'));
        verify(mockRemoteDatasource.getDistrik(tKotaId));
      },
    );
  });
}
