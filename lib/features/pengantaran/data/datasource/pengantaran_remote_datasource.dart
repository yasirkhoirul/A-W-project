import 'dart:convert';
import 'dart:io';

import 'package:a_and_w/core/exceptions/http_api_exception.dart';
import 'package:a_and_w/features/pengantaran/data/model/cost_request_model.dart';
import 'package:a_and_w/features/pengantaran/data/model/cost_response_model.dart';
import 'package:a_and_w/features/pengantaran/data/model/distrik_response.dart';
import 'package:a_and_w/features/pengantaran/data/model/track_request_model.dart';
import 'package:a_and_w/features/pengantaran/data/model/track_response_model.dart';
import 'package:a_and_w/features/pengantaran/data/model/kota_response.dart';
import 'package:a_and_w/features/pengantaran/data/model/provinsi_response.dart';
import 'package:a_and_w/core/constant/baseurl.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

abstract class PengantaranRemoteDatasource {
  Future<ProvinsiResponse> getProvinsi();
  Future<KotaResponse> getKota(String provinsiId);
  Future<DistrikResponse> getDistrik(String kotaId);
  Future<CostResponse> getCost(CostRequestModel data);
  Future<TrackResponse> getTrack(TrackRequestModel data);
}

class PengantaranRemoteDatasourceImpl implements PengantaranRemoteDatasource {
  final String apiKey;
  final http.Client client;
  
  PengantaranRemoteDatasourceImpl(
    this.client, {
    String? apiKey,
  }) : apiKey = apiKey ??
            const String.fromEnvironment(
              'RAJAONGKIR_KEY',
              defaultValue: '',
            );

  void _validateApiKey() {
    if (apiKey.isEmpty) {
      Logger().e('RajaOngkir API Key tidak ditemukan!');
      throw const HttpApiException(
        'API Key tidak ditemukan. Set dengan: flutter run --dart-define=RAJAONGKIR_KEY=your_key',
      );
    }
  }

  Map<String, String> _headers({bool isPost = false}) {
    final headers = {'key': apiKey};
    if (isPost) {
      headers['Content-Type'] = 'application/x-www-form-urlencoded';
    }
    return headers;
  }
  

  @override
  Future<ProvinsiResponse> getProvinsi() async {
    _validateApiKey();
    try {
      Logger().d('GET header: ${_headers()}');
      final uri = Uri.parse('${Baseurl.baseurlRajaOngkir}destination/province');
      final response = await client.get(uri, headers: _headers());
      Logger().d('GET $uri - Status: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw HttpApiException.fromStatusCode(response.statusCode);
      }

      final jsonData = jsonDecode(response.body);
      return ProvinsiResponse.fromJson(jsonData);
    } on SocketException {
      throw const HttpNetworkException("Tidak ada koneksi internet");
    } on HttpException {
      rethrow;
    } catch (e) {
      throw HttpUnknownException("Terjadi kesalahan: $e");
    }
  }

  @override
  Future<KotaResponse> getKota(String provinsiId) async {
    _validateApiKey();
    try {
      final uri = Uri.parse(
        '${Baseurl.baseurlRajaOngkir}destination/city/$provinsiId',
      );
      final response = await client.get(uri, headers: _headers());

      if (response.statusCode != 200) {
        throw HttpApiException.fromStatusCode(response.statusCode);
      }

      final jsonData = jsonDecode(response.body);
      return KotaResponse.fromJson(jsonData);
    } on SocketException {
      throw const HttpNetworkException("Tidak ada koneksi internet");
    } on HttpException {
      rethrow;
    } catch (e) {
      throw HttpUnknownException("Terjadi kesalahan: $e");
    }
  }

  @override
  Future<DistrikResponse> getDistrik(String kotaId) async {
    _validateApiKey();
    try {
      final uri = Uri.parse(
        '${Baseurl.baseurlRajaOngkir}destination/district/$kotaId',
      );
      final response = await client.get(uri, headers: _headers());

      if (response.statusCode != 200) {
        throw HttpApiException.fromStatusCode(response.statusCode);
      }

      final jsonData = jsonDecode(response.body);
      return DistrikResponse.fromJson(jsonData);
    } on SocketException {
      throw const HttpNetworkException("Tidak ada koneksi internet");
    } on HttpException {
      rethrow;
    } catch (e) {
      throw HttpUnknownException("Terjadi kesalahan: $e");
    }
  }

  @override
  Future<CostResponse> getCost(CostRequestModel data) async {
    _validateApiKey();
    try {
      final formData = {
        'origin': data.origin.toString(),
        'destination': data.destination.toString(),
        'weight': data.weight.toString(),
        'courier': data.courier,
      };
      Logger().d('Cost API req: Form data: $formData');
      final uri = Uri.parse(
        '${Baseurl.baseurlRajaOngkir}calculate/domestic-cost',
      );
      final headers = _headers(isPost: true);
      Logger().d('Cost API req: Headers: $headers');
      final response = await client.post(
        uri,
        headers: headers,
        body: formData,
      );
      Logger().d('Cost API response status: ${response.statusCode}');
      Logger().d('Cost API response body: ${response.body}');

      if (response.statusCode != 200) {
        throw HttpApiException.fromStatusCode(response.statusCode);
      }

      final jsonData = jsonDecode(response.body);
      Logger().d('Cost API parsed response: $jsonData');
      return CostResponse.fromJson(jsonData);
    } on SocketException {
      throw const HttpNetworkException("Tidak ada koneksi internet");
    } on HttpException {
      rethrow;
    } catch (e) {
      throw HttpUnknownException("Terjadi kesalahan: $e");
    }
  }

  @override
  Future<TrackResponse> getTrack(TrackRequestModel data) async {
    Logger().d('Track API req: Data: ${data.toJson()}');
    _validateApiKey();
    try {
      final uri = Uri.parse(
        '${Baseurl.baseurlRajaOngkir}track/waybill',
      ).replace(queryParameters: {
        'awb': data.waybill,
        'courier': data.courier,
        'last_phone_number': data.lastPhoneNumber.toString(),
      });
      Logger().d('Track API full URL: $uri');
      final response = await client.post(uri, headers: _headers());
      Logger().d('Track API response status: ${response.statusCode}');
      Logger().d('Track API response body: ${response.body}');
      if (response.statusCode != 200) {
        throw HttpApiException.fromStatusCode(response.statusCode);
      }

      final jsonData = jsonDecode(response.body);
      return TrackResponse.fromJson(jsonData);
    } on SocketException {
      throw const HttpNetworkException("Tidak ada koneksi internet");
    } on HttpException {
      rethrow;
    } catch (e) {
      throw HttpUnknownException("Terjadi kesalahan: $e");
    }
  }
}
