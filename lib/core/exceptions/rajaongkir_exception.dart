/// Base exception untuk HTTP API
class HttpException implements Exception {
  final String message;

  const HttpException(this.message);

  @override
  String toString() => message;
}

/// Exception untuk HTTP API errors dengan status code
class HttpApiException extends HttpException {
  const HttpApiException(super.message);
  
  factory HttpApiException.fromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return const HttpApiException('Bad Request: Permintaan tidak valid');
      case 401:
        return const HttpApiException('Unauthorized: Kunci API tidak valid');
      case 403:
        return const HttpApiException('Forbidden: Akses ditolak');
      case 404:
        return const HttpApiException('Not Found: Sumber daya tidak ditemukan');
      case 429:
        return const HttpApiException('Too Many Requests: Terlalu banyak permintaan');
      case 500:
        return const HttpApiException('Internal Server Error: Kesalahan pada server');
      case 502:
        return const HttpApiException('Bad Gateway: Gateway tidak valid');
      case 503:
        return const HttpApiException('Service Unavailable: Layanan tidak tersedia');
      default:
        return HttpApiException('Terjadi kesalahan: $statusCode');
    }
  }
}

/// Exception untuk network errors
class HttpNetworkException extends HttpException {
  const HttpNetworkException(super.message);
}

/// Exception untuk unknown errors
class HttpUnknownException extends HttpException {
  const HttpUnknownException(super.message);
}