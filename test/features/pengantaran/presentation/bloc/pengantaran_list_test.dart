import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_wilayah_entity.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/get_list_distrik.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/get_list_kota.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/get_list_provinsi.dart';
import 'package:a_and_w/features/pengantaran/presentation/bloc/pengantaran_list_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_helper.mocks.dart';
import 'pengantaran_list_test.mocks.dart';

@GenerateMocks([GetListDistrik, GetListProvinsi, GetListKota])
late MockPengantaranRepository mockPengantaranRepository;
late MockGetListDistrik mockGetListDistrik;
late MockGetListProvinsi mockGetListProvinsi;
late MockGetListKota mockGetListKota;
late PengantaranListBloc pengantaranListBloc;
void main() {
  setUp(() {
    mockPengantaranRepository = MockPengantaranRepository();
    mockGetListDistrik = MockGetListDistrik();
    mockGetListProvinsi = MockGetListProvinsi();
    mockGetListKota = MockGetListKota();
    pengantaranListBloc = PengantaranListBloc(
      mockGetListProvinsi,
      mockGetListKota,
      mockGetListDistrik,
    );
  });
  final tListProvinsi = [
    DataWilayahEntity(id: 1, name: "Jawa Barat"),
    DataWilayahEntity(id: 2, name: "Jawa Tengah"),
  ];
  group("test pengantaran list bloc", () {
    group("test get list provinsi", () {
      blocTest<PengantaranListBloc, PengantaranListState>(
        ("test get list provinsi"),
        setUp: () {
          when(
            mockGetListProvinsi(),
          ).thenAnswer((_) async => Right(tListProvinsi));
        },
        build: () => pengantaranListBloc,
        act: (bloc) => bloc.add(OnPengantaranProvinsiList()),
        expect: () => [
          PengantaranListLoading(),
          PengantaranListLoaded(data: tListProvinsi),
        ],
        verify: (_) {
          verify(mockGetListProvinsi()).called(1);
        },
      );
      blocTest<PengantaranListBloc, PengantaranListState>(
        ("test get list provinsi http api failure"),
        setUp: () {
          when(
            mockGetListProvinsi(),
          ).thenAnswer((_) async => Left(HttpApiFailure("error")));
        },
        build: () => pengantaranListBloc,
        act: (bloc) => bloc.add(OnPengantaranProvinsiList()),
        expect: () => [
          PengantaranListLoading(),
          PengantaranListError(message: "error"),
        ],
        verify: (_) {
          verify(mockGetListProvinsi()).called(1);
        },
      );
      blocTest<PengantaranListBloc, PengantaranListState>(
        ("test get list provinsi network failure"),
        setUp: () {
          when(
            mockGetListProvinsi(),
          ).thenAnswer((_) async => Left(NetworkFailure()));
        },
        build: () => pengantaranListBloc,
        act: (bloc) => bloc.add(OnPengantaranProvinsiList()),
        expect: () => [
          PengantaranListLoading(),
          PengantaranListError(message: "Tidak ada koneksi internet"),
        ],
        verify: (_) {
          verify(mockGetListProvinsi()).called(1);
        },
      );
      blocTest<PengantaranListBloc, PengantaranListState>(
        ("test get list provinsi unknown failure"),
        setUp: () {
          when(
            mockGetListProvinsi(),
          ).thenAnswer((_) async => Left(UnknownFailure()));
        },
        build: () => pengantaranListBloc,
        act: (bloc) => bloc.add(OnPengantaranProvinsiList()),
        expect: () => [
          PengantaranListLoading(),
          PengantaranListError(message: "Terjadi kesalahan"),
        ],
        verify: (_) {
          verify(mockGetListProvinsi()).called(1);
        },
      );
    });
    group("test get list kota", () {
      blocTest<PengantaranListBloc, PengantaranListState>(
        ("test get list kota success"),
        setUp: () {
          when(
            mockGetListKota("1"),
          ).thenAnswer((_) async => Right(tListProvinsi));
        },
        build: () => pengantaranListBloc,
        act: (bloc) => bloc.add(const OnPengantaranKotaList(provinsiId: "1")),
        expect: () => [
          PengantaranListLoading(),
          PengantaranListLoaded(data: tListProvinsi),
        ],
        verify: (_) {
          verify(mockGetListKota("1")).called(1);
        },
      );
      blocTest<PengantaranListBloc, PengantaranListState>(
        ("test get list kota http api failure"),
        setUp: () {
          when(
            mockGetListKota("1"),
          ).thenAnswer((_) async => Left(HttpApiFailure("error")));
        },
        build: () => pengantaranListBloc,
        act: (bloc) => bloc.add(const OnPengantaranKotaList(provinsiId: "1")),
        expect: () => [
          PengantaranListLoading(),
          PengantaranListError(message: "error"),
        ],
        verify: (_) {
          verify(mockGetListKota("1")).called(1);
        },
      );
      blocTest<PengantaranListBloc, PengantaranListState>(
        ("test get list kota network failure"),
        setUp: () {
          when(
            mockGetListKota("1"),
          ).thenAnswer((_) async => Left(NetworkFailure()));
        },
        build: () => pengantaranListBloc,
        act: (bloc) => bloc.add(const OnPengantaranKotaList(provinsiId: "1")),
        expect: () => [
          PengantaranListLoading(),
          PengantaranListError(message: "Tidak ada koneksi internet"),
        ],
        verify: (_) {
          verify(mockGetListKota("1")).called(1);
        },
      );
      blocTest<PengantaranListBloc, PengantaranListState>(
        ("test get list kota unknown failure"),
        setUp: () {
          when(
            mockGetListKota("1"),
          ).thenAnswer((_) async => Left(UnknownFailure()));
        },
        build: () => pengantaranListBloc,
        act: (bloc) => bloc.add(const OnPengantaranKotaList(provinsiId: "1")),
        expect: () => [
          PengantaranListLoading(),
          PengantaranListError(message: "Terjadi kesalahan"),
        ],
        verify: (_) {
          verify(mockGetListKota("1")).called(1);
        },
      );
    });
    group("test get list distrik", () {
      blocTest<PengantaranListBloc, PengantaranListState>(
        ("test get list distrik success"),
        setUp: () {
          when(
            mockGetListDistrik("10"),
          ).thenAnswer((_) async => Right(tListProvinsi));
        },
        build: () => pengantaranListBloc,
        act: (bloc) => bloc.add(const OnPengantaranDistrikList(kotaId: "10")),
        expect: () => [
          PengantaranListLoading(),
          PengantaranListLoaded(data: tListProvinsi),
        ],
        verify: (_) {
          verify(mockGetListDistrik("10")).called(1);
        },
      );
      blocTest<PengantaranListBloc, PengantaranListState>(
        ("test get list distrik http api failure"),
        setUp: () {
          when(
            mockGetListDistrik("10"),
          ).thenAnswer((_) async => Left(HttpApiFailure("error")));
        },
        build: () => pengantaranListBloc,
        act: (bloc) => bloc.add(const OnPengantaranDistrikList(kotaId: "10")),
        expect: () => [
          PengantaranListLoading(),
          PengantaranListError(message: "error"),
        ],
        verify: (_) {
          verify(mockGetListDistrik("10")).called(1);
        },
      );
      blocTest<PengantaranListBloc, PengantaranListState>(
        ("test get list distrik network failure"),
        setUp: () {
          when(
            mockGetListDistrik("10"),
          ).thenAnswer((_) async => Left(NetworkFailure()));
        },
        build: () => pengantaranListBloc,
        act: (bloc) => bloc.add(const OnPengantaranDistrikList(kotaId: "10")),
        expect: () => [
          PengantaranListLoading(),
          PengantaranListError(message: "Tidak ada koneksi internet"),
        ],
        verify: (_) {
          verify(mockGetListDistrik("10")).called(1);
        },
      );
      blocTest<PengantaranListBloc, PengantaranListState>(
        ("test get list distrik unknown failure"),
        setUp: () {
          when(
            mockGetListDistrik("10"),
          ).thenAnswer((_) async => Left(UnknownFailure()));
        },
        build: () => pengantaranListBloc,
        act: (bloc) => bloc.add(const OnPengantaranDistrikList(kotaId: "10")),
        expect: () => [
          PengantaranListLoading(),
          PengantaranListError(message: "Terjadi kesalahan"),
        ],
        verify: (_) {
          verify(mockGetListDistrik("10")).called(1);
        },
      );
    });
  });
}
