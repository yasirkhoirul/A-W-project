import 'package:a_and_w/features/pesanan/domain/entities/pesanan.dart';

/// Response model dari Cloud Function createTransaction
class SubmitPesananResponseModel {
  final String token;
  final String redirectUrl;
  final String orderId;

  const SubmitPesananResponseModel({
    required this.token,
    required this.redirectUrl,
    required this.orderId,
  });

  factory SubmitPesananResponseModel.fromJson(Map<String, dynamic> json) {
    return SubmitPesananResponseModel(
      token: json['token'] as String,
      redirectUrl: json['redirectUrl'] as String,
      orderId: json['orderId'] as String,
    );
  }

  /// Convert to domain entity
  SubmitPesananEntity toEntity() => SubmitPesananEntity(
    token: token,
    redirectUrl: redirectUrl,
    orderId: orderId,
  );
}
