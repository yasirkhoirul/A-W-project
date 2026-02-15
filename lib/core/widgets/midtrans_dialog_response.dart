import 'package:a_and_w/core/constant/enum.dart';
import 'package:a_and_w/core/router/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DialogBayar extends StatefulWidget {
  final String riderectUrl;
  final VoidCallback? onCancel;
  const DialogBayar({super.key, required this.riderectUrl, this.onCancel});

  @override
  State<DialogBayar> createState() => _DialogBayarState();
}


class _DialogBayarState extends State<DialogBayar> {
  ResponseMidtrans? resultBack;

  ResponseMidtrans? _mapStatus(String? status) {
    if (status == null) return null;
    try {
      if (status == 'failure') return ResponseMidtrans.failed;
      return ResponseMidtrans.values.firstWhere(
        (e) => e.name == status,
        orElse: () => ResponseMidtrans.pending,
      );
    } catch (e) {
      return ResponseMidtrans.pending;
    }
  }

  Icon _getIcon(ResponseMidtrans status) {
    switch (status) {
      case ResponseMidtrans.capture:
      case ResponseMidtrans.settlement:
        return const Icon(Icons.check_circle, color: Colors.green, size: 80);
      case ResponseMidtrans.pending:
        return const Icon(Icons.access_time, color: Colors.orange, size: 80);
      case ResponseMidtrans.deny:
      case ResponseMidtrans.expire:
      case ResponseMidtrans.cancel:
      case ResponseMidtrans.failed:
        return const Icon(Icons.error, color: Colors.red, size: 80);
    }
  }

  Widget _getTitle(ResponseMidtrans status) {
    switch (status) {
      case ResponseMidtrans.capture:
      case ResponseMidtrans.settlement:
        return const Text('Pembayaran Berhasil!');
      case ResponseMidtrans.pending:
        return const Text('Menunggu Pembayaran');
      case ResponseMidtrans.deny:
      case ResponseMidtrans.expire:
      case ResponseMidtrans.cancel:
      case ResponseMidtrans.failed:
        return const Text('Pembayaran Gagal');
    }
  }

  Widget _getContent(ResponseMidtrans status) {
    switch (status) {
      case ResponseMidtrans.capture:
      case ResponseMidtrans.settlement:
        return const Text('Terima kasih, pembayaran Anda telah berhasil.');
      case ResponseMidtrans.pending:
        return const Text('Silakan selesaikan pembayaran Anda.');
      case ResponseMidtrans.deny:
      case ResponseMidtrans.expire:
      case ResponseMidtrans.cancel:
      case ResponseMidtrans.failed:
        return const Text('Maaf, pembayaran Anda gagal atau dibatalkan.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (resultBack != null) {
      return PopScope(
        onPopInvoked: (didPop) {
          if (didPop && widget.onCancel != null) {
            widget.onCancel!();
          }
        },
        child: AlertDialog(
          icon: _getIcon(resultBack!),
          title: _getTitle(resultBack!),
          content: _getContent(resultBack!),
          actions: [
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop && widget.onCancel != null) {
          widget.onCancel!();
        }
      },
      child: AlertDialog(
        icon: const Icon(Icons.payment, color: Colors.blue, size: 80),
        title: const Text('Lanjut ke Pembayaran'),
        content: const Text(
          'Pesanan Anda telah dibuat. Silakan lanjut ke halaman pembayaran Midtrans.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final result = await context.pushNamed(
                AppRouter.pembayaran,
                pathParameters: {'url': widget.riderectUrl},
              );
              if (result != null) {
                final status = _mapStatus(result as String);
                setState(() {
                  resultBack = status;
                });
              } else {
              }
            },
            child: const Text('Bayar Sekarang'),
          ),
        ],
      ),
    );
  }
}
