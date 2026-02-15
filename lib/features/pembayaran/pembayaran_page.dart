import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PembayaranPage extends StatefulWidget {
  final String url;
  const PembayaranPage({super.key, required this.url});

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  late final WebViewController _webViewController;
  bool isLoading = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (error) {
            setState(() {
              isLoading = false;
              isError = true;
            });
          },
          onNavigationRequest: (request) {
            if (request.url.contains('gojek://') ||
                request.url.contains('shopeepaid://') ||
                request.url.contains('waze://')) {
              return NavigationDecision.navigate;
            }

            if (request.url.contains('example.com') ||
                request.url.contains('/finish')) {
              final uri = Uri.parse(request.url);
              final status = uri.queryParameters['transaction_status'];
              context.pop(status);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
