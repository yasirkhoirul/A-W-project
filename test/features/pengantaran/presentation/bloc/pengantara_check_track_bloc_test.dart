import 'package:a_and_w/core/exceptions/failure.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_cek_entity.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_track_entity.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/cost_pengantaran.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/track_pengantaran.dart';
import 'package:a_and_w/features/pengantaran/presentation/bloc/pengantara_check_track_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'pengantara_check_track_bloc_test.mocks.dart';

@GenerateMocks([CostPengantaran, TrackPengantaran])
void main() {
  late MockCostPengantaran mockCostPengantaran;
  late MockTrackPengantaran mockTrackPengantaran;
  late PengantaraCheckTrackBloc bloc;

  setUp(() {
    mockCostPengantaran = MockCostPengantaran();
    mockTrackPengantaran = MockTrackPengantaran();
    bloc = PengantaraCheckTrackBloc(mockCostPengantaran, mockTrackPengantaran);
  });

  tearDown(() {
    bloc.close();
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
  ];

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

  group('PengantaraCheckTrackBloc', () {
    test('initial state should be PengantaraCheckTrackInitial', () {
      expect(bloc.state, isA<PengantaraCheckTrackInitial>());
    });

    // ==================== CHECK COST TESTS ====================
    group('OnPengantaranCheckCost', () {
      blocTest<PengantaraCheckTrackBloc, PengantaraCheckTrackState>(
        'should emit [Loading, CostLoaded] when cost check is successful',
        setUp: () {
          when(
            mockCostPengantaran(any),
          ).thenAnswer((_) async => const Right(tDataCekEntityList));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(
          OnPengantaranCheckCost(dataTrackRequestEntity: tDataCekRequestEntity),
        ),
        expect: () => [
          PengantaraCheckTrackLoading(),
          const PengantaraCheckTrackCostLoaded(
            dataCekEntity: tDataCekEntityList,
          ),
        ],
        verify: (_) {
          verify(mockCostPengantaran(tDataCekRequestEntity)).called(1);
        },
      );

      blocTest<PengantaraCheckTrackBloc, PengantaraCheckTrackState>(
        'should emit [Loading, Error] when cost check returns NetworkFailure',
        setUp: () {
          when(
            mockCostPengantaran(any),
          ).thenAnswer((_) async => const Left(NetworkFailure()));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(
          OnPengantaranCheckCost(dataTrackRequestEntity: tDataCekRequestEntity),
        ),
        expect: () => [
          PengantaraCheckTrackLoading(),
          const PengantaraCheckTrackError(
            message: 'Tidak ada koneksi internet',
          ),
        ],
        verify: (_) {
          verify(mockCostPengantaran(tDataCekRequestEntity)).called(1);
        },
      );

      blocTest<PengantaraCheckTrackBloc, PengantaraCheckTrackState>(
        'should emit [Loading, Error] when cost check returns HttpApiFailure',
        setUp: () {
          when(
            mockCostPengantaran(any),
          ).thenAnswer((_) async => const Left(HttpApiFailure('API Error')));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(
          OnPengantaranCheckCost(dataTrackRequestEntity: tDataCekRequestEntity),
        ),
        expect: () => [
          PengantaraCheckTrackLoading(),
          const PengantaraCheckTrackError(message: 'API Error'),
        ],
        verify: (_) {
          verify(mockCostPengantaran(tDataCekRequestEntity)).called(1);
        },
      );

      blocTest<PengantaraCheckTrackBloc, PengantaraCheckTrackState>(
        'should emit [Loading, Error] when cost check returns UnknownFailure',
        setUp: () {
          when(mockCostPengantaran(any)).thenAnswer(
            (_) async => const Left(UnknownFailure('Unknown error')),
          );
        },
        build: () => bloc,
        act: (bloc) => bloc.add(
          OnPengantaranCheckCost(dataTrackRequestEntity: tDataCekRequestEntity),
        ),
        expect: () => [
          PengantaraCheckTrackLoading(),
          const PengantaraCheckTrackError(message: 'Unknown error'),
        ],
        verify: (_) {
          verify(mockCostPengantaran(tDataCekRequestEntity)).called(1);
        },
      );
    });

    // ==================== CHECK TRACK TESTS ====================
    group('OnPengantaranCheckTrack', () {
      blocTest<PengantaraCheckTrackBloc, PengantaraCheckTrackState>(
        'should emit [Loading, Loaded] when track check is successful',
        setUp: () {
          when(
            mockTrackPengantaran(any),
          ).thenAnswer((_) async => const Right(tDataTrackEntityList));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(
          const OnPengantaranCheckTrack(
            dataTrackRequestEntity: tDataTrackRequestEntity,
          ),
        ),
        expect: () => [
          PengantaraCheckTrackLoading(),
          const PengantaraCheckTrackLoaded(dataCekEntity: tDataTrackEntityList),
        ],
        verify: (_) {
          verify(mockTrackPengantaran(tDataTrackRequestEntity)).called(1);
        },
      );

      blocTest<PengantaraCheckTrackBloc, PengantaraCheckTrackState>(
        'should emit [Loading, Error] when track check returns NetworkFailure',
        setUp: () {
          when(
            mockTrackPengantaran(any),
          ).thenAnswer((_) async => const Left(NetworkFailure()));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(
          const OnPengantaranCheckTrack(
            dataTrackRequestEntity: tDataTrackRequestEntity,
          ),
        ),
        expect: () => [
          PengantaraCheckTrackLoading(),
          const PengantaraCheckTrackError(
            message: 'Tidak ada koneksi internet',
          ),
        ],
        verify: (_) {
          verify(mockTrackPengantaran(tDataTrackRequestEntity)).called(1);
        },
      );

      blocTest<PengantaraCheckTrackBloc, PengantaraCheckTrackState>(
        'should emit [Loading, Error] when track check returns HttpApiFailure',
        setUp: () {
          when(mockTrackPengantaran(any)).thenAnswer(
            (_) async => const Left(HttpApiFailure('Tracking not found')),
          );
        },
        build: () => bloc,
        act: (bloc) => bloc.add(
          const OnPengantaranCheckTrack(
            dataTrackRequestEntity: tDataTrackRequestEntity,
          ),
        ),
        expect: () => [
          PengantaraCheckTrackLoading(),
          const PengantaraCheckTrackError(message: 'Tracking not found'),
        ],
        verify: (_) {
          verify(mockTrackPengantaran(tDataTrackRequestEntity)).called(1);
        },
      );

      blocTest<PengantaraCheckTrackBloc, PengantaraCheckTrackState>(
        'should emit [Loading, Error] when track check returns UnknownFailure',
        setUp: () {
          when(mockTrackPengantaran(any)).thenAnswer(
            (_) async => const Left(UnknownFailure('Unknown error')),
          );
        },
        build: () => bloc,
        act: (bloc) => bloc.add(
          const OnPengantaranCheckTrack(
            dataTrackRequestEntity: tDataTrackRequestEntity,
          ),
        ),
        expect: () => [
          PengantaraCheckTrackLoading(),
          const PengantaraCheckTrackError(message: 'Unknown error'),
        ],
        verify: (_) {
          verify(mockTrackPengantaran(tDataTrackRequestEntity)).called(1);
        },
      );
    });
  });
}
