import 'dart:convert';
import 'dart:io';

import 'package:a_and_w/core/exceptions/http_api_exception.dart';
import 'package:a_and_w/features/pengantaran/data/model/distrik_response.dart';
import 'package:a_and_w/features/pengantaran/data/model/kota_response.dart';
import 'package:a_and_w/features/pengantaran/data/model/provinsi_response.dart';
import 'package:a_and_w/core/constant/baseurl.dart';
import 'package:http/http.dart' as http;

abstract class PengantaranRemoteDatasource {
  Future<ProvinsiResponse> getProvinsi();
  Future<KotaResponse> getKota(String provinsiId);
  Future<DistrikResponse> getDistrik(String kotaId);
}

class PengantaranRemoteDatasourceImpl implements PengantaranRemoteDatasource{
  static const String apiKey = String.fromEnvironment(
    'RAJAONGKIR_KEY', 
    defaultValue: 'KEY_TIDAK_DITEMUKAN'
  );
  final http.Client client;
  PengantaranRemoteDatasourceImpl(this.client){
    _checkApiKeyPresence();
  }

  void _checkApiKeyPresence() {
    if (apiKey.isEmpty) {
      throw const HttpApiException(
        'API Key tidak ditemukan. Set dengan: flutter run --dart-define=RAJAONGKIR_KEY=your_key'
      );
    }
  }

  Map<String, String> _headers() => {'key': apiKey};

  @override
  Future<ProvinsiResponse> getProvinsi() async {
    try {
      final uri = Uri.parse('${Baseurl.baseurlRajaOngkir}province');
      final response = await client.get(uri, headers: _headers());
      
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
    try {
      final uri = Uri.parse('${Baseurl.baseurlRajaOngkir}city?province=$provinsiId');
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
    try {
      final uri = Uri.parse('${Baseurl.baseurlRajaOngkir}subdistrict?city=$kotaId');
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

}