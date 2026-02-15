import 'package:equatable/equatable.dart';

/// Entity hasil submit pesanan ke Midtrans
class SubmitPesananEntity extends Equatable {
  final String token; // Midtrans Snap token
  final String redirectUrl; // URL payment page
  final String orderId; // Unique order ID

  const SubmitPesananEntity({
    required this.token,
    required this.redirectUrl,
    required this.orderId,
  });

  @override
  List<Object?> get props => [token, redirectUrl, orderId];
}
