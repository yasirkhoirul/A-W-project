import 'dart:convert';
import 'dart:io';

import 'package:a_and_w/core/constant/baseurl.dart';
import 'package:a_and_w/core/exceptions/http_api_exception.dart';
import 'package:a_and_w/features/pengantaran/data/datasource/pengantaran_remote_datasource.dart';
import 'package:a_and_w/features/pengantaran/data/model/distrik_response.dart';
import 'package:a_and_w/features/pengantaran/data/model/kota_response.dart';
import 'package:a_and_w/features/pengantaran/data/model/provinsi_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'pengantaran_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late PengantaranRemoteDatasourceImpl datasource;

  setUp(() {
    mockClient = MockClient();
    datasource = PengantaranRemoteDatasourceImpl(mockClient);
  });

  group('getProvinsi', () {
    const tUrl = '${Baseurl.baseurlRajaOngkir}province';

    test('should return ProvinsiResponse when status code is 200', () async {
      // Arrange
      final jsonFile = File('test/dummy_data/raja_ongkir_provinsi.json');
      final jsonString = await jsonFile.readAsString();
      
      when(mockClient.get(
        Uri.parse(tUrl),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(jsonString, 200));

      // Act
      final result = await datasource.getProvinsi();

      // Assert
      expect(result, isA<ProvinsiResponse>());
      expect(result.meta, isNotNull);
      expect(result.meta?.code, 200);
      expect(result.meta?.status, 'success');
      expect(result.data, isNotNull);
      expect(result.data?.length, 34);
      expect(result.data?.first.id, '1');
      expect(result.data?.first.name, 'NUSA TENGGARA BARAT (NTB)');
    });

    test('should return ProvinsiResponse with null data when data is empty', () async {
      // Arrange
      final jsonResponse = jsonEncode({
        'meta': {
          'message': 'Success Get Province',
          'code': 200,
          'status': 'success'
        },
        'data': null
      });
      
      when(mockClient.get(
        Uri.parse(tUrl),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(jsonResponse, 200));

      // Act
      final result = await datasource.getProvinsi();

      // Assert
      expect(result, isA<ProvinsiResponse>());
      expect(result.data, isNull);
    });

    test('should throw HttpApiException when status code is not 200', () async {
      // Arrange
      when(mockClient.get(
        Uri.parse(tUrl),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Not Found', 404));

      // Act
      final call = datasource.getProvinsi;

      // Assert
      expect(() => call(), throwsA(isA<HttpApiException>()));
    });

    test('should throw HttpNetworkException when network error occurs', () async {
      // Arrange
      when(mockClient.get(
        Uri.parse(tUrl),
        headers: anyNamed('headers'),
      )).thenThrow(const SocketException('No Internet'));

      // Act
      final call = datasource.getProvinsi;

      // Assert
      expect(() => call(), throwsA(isA<HttpNetworkException>()));
    });
  });

  group('getKota', () {
    const tProvinsiId = '2';
    const tUrl = '${Baseurl.baseurlRajaOngkir}city?province=$tProvinsiId';

    test('should return KotaResponse when status code is 200', () async {
      // Arrange
      final jsonFile = File('test/dummy_data/raja_ongkir_kota.json');
      final jsonString = await jsonFile.readAsString();
      
      when(mockClient.get(
        Uri.parse(tUrl),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(jsonString, 200));

      // Act
      final result = await datasource.getKota(tProvinsiId);

      // Assert
      expect(result, isA<KotaResponse>());
      expect(result.meta, isNotNull);
      expect(result.meta?.code, 200);
      expect(result.meta?.status, 'success');
      expect(result.data, isNotNull);
      expect(result.data?.length, 11);
      expect(result.data?.first.id, '11');
      expect(result.data?.first.name, 'AMBON');
    });

    test('should return KotaResponse with null data when data is empty', () async {
      // Arrange
      final jsonResponse = jsonEncode({
        'meta': {
          'message': 'Success Get City By Province ID',
          'code': 200,
          'status': 'success'
        },
        'data': null
      });
      
      when(mockClient.get(
        Uri.parse(tUrl),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(jsonResponse, 200));

      // Act
      final result = await datasource.getKota(tProvinsiId);

      // Assert
      expect(result, isA<KotaResponse>());
      expect(result.data, isNull);
    });

    test('should throw HttpApiException when status code is not 200', () async {
      // Arrange
      when(mockClient.get(
        Uri.parse(tUrl),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Not Found', 404));

      // Act
      final call = datasource.getKota;

      // Assert
      expect(() => call(tProvinsiId), throwsA(isA<HttpApiException>()));
    });

    test('should throw HttpNetworkException when network error occurs', () async {
      // Arrange
      when(mockClient.get(
        Uri.parse(tUrl),
        headers: anyNamed('headers'),
      )).thenThrow(const SocketException('No Internet'));

      // Act
      final call = datasource.getKota;

      // Assert
      expect(() => call(tProvinsiId), throwsA(isA<HttpNetworkException>()));
    });
  });

  group('getDistrik', () {
    const tKotaId = '123';
    const tUrl = '${Baseurl.baseurlRajaOngkir}subdistrict?city=$tKotaId';

    test('should return DistrikResponse when status code is 200', () async {
      // Arrange
      final jsonFile = File('test/dummy_data/raja_ongkir_distrik.json');
      final jsonString = await jsonFile.readAsString();
      
      when(mockClient.get(
        Uri.parse(tUrl),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(jsonString, 200));

      // Act
      final result = await datasource.getDistrik(tKotaId);

      // Assert
      expect(result, isA<DistrikResponse>());
      expect(result.meta, isNotNull);
      expect(result.meta?.code, 200);
      expect(result.meta?.status, 'success');
      expect(result.data, isNotNull);
      expect(result.data?.length, 18);
      expect(result.data?.first.id, '5816');
      expect(result.data?.first.name, 'PURBALINGGA');
    });

    test('should return DistrikResponse with null data when data is empty', () async {
      // Arrange
      final jsonResponse = jsonEncode({
        'meta': {
          'message': 'Success Get District By City ID',
          'code': 200,
          'status': 'success'
        },
        'data': null
      });
      
      when(mockClient.get(
        Uri.parse(tUrl),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(jsonResponse, 200));

      // Act
      final result = await datasource.getDistrik(tKotaId);

      // Assert
      expect(result, isA<DistrikResponse>());
      expect(result.data, isNull);
    });

    test('should throw HttpApiException when status code is not 200', () async {
      // Arrange
      when(mockClient.get(
        Uri.parse(tUrl),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Not Found', 404));

      // Act
      final call = datasource.getDistrik;

      // Assert
      expect(() => call(tKotaId), throwsA(isA<HttpApiException>()));
    });

    test('should throw HttpNetworkException when network error occurs', () async {
      // Arrange
      when(mockClient.get(
        Uri.parse(tUrl),
        headers: anyNamed('headers'),
      )).thenThrow(const SocketException('No Internet'));

      // Act
      final call = datasource.getDistrik;
      // Assert
      expect(() => call(tKotaId), throwsA(isA<HttpNetworkException>()));
    });
  });
}
