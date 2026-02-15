import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

/// Base exception untuk Firebase
class FirebaseException implements Exception {
  final String message;
  final String? code;

  const FirebaseException(this.message, [this.code]);

  @override
  String toString() => message;
}

/// Exception untuk Firebase Authentication
class AuthException extends FirebaseException {
  const AuthException(super.message, [super.code]);

  factory AuthException.fromFirebase(firebase_auth.FirebaseAuthException e) {
    return AuthException(_getAuthMessage(e.code), e.code);
  }

  static String _getAuthMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'user-disabled':
        return 'Akun telah dinonaktifkan';
      case 'user-not-found':
        return 'Email tidak terdaftar';
      case 'wrong-password':
        return 'Password salah';
      case 'email-already-in-use':
        return 'Email sudah terdaftar';
      case 'weak-password':
        return 'Password terlalu lemah. Minimal 6 karakter';
      case 'requires-recent-login':
        return 'Silakan login ulang';
      case 'invalid-credential':
        return 'Kredensial tidak valid';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti';
      default:
        return 'Terjadi kesalahan: $code';
    }
  }
}

/// Exception untuk Firestore
class DatabaseException extends FirebaseException {
  const DatabaseException(super.message, [super.code]);

  factory DatabaseException.fromFirebase(firebase_auth.FirebaseException e) {
    return DatabaseException(_getDatabaseMessage(e.code), e.code);
  }

  static String _getDatabaseMessage(String code) {
    switch (code) {
      case 'permission-denied':
        return 'Tidak memiliki izin akses';
      case 'not-found':
        return 'Data tidak ditemukan';
      case 'already-exists':
        return 'Data sudah ada';
      case 'unavailable':
        return 'Layanan tidak tersedia';
      case 'unauthenticated':
        return 'Anda belum login';
      default:
        return 'Terjadi kesalahan database: $code';
    }
  }
}

/// Exception untuk Storage
class StorageException extends FirebaseException {
  const StorageException(super.message, [super.code]);

  factory StorageException.fromFirebase(firebase_auth.FirebaseException e) {
    return StorageException(_getStorageMessage(e.code), e.code);
  }

  static String _getStorageMessage(String code) {
    switch (code) {
      case 'object-not-found':
        return 'File tidak ditemukan';
      case 'unauthorized':
        return 'Tidak memiliki izin akses';
      case 'canceled':
        return 'Upload dibatalkan';
      case 'unknown':
        return 'Terjadi kesalahan storage';
      default:
        return 'Terjadi kesalahan: $code';
    }
  }
}

/// Exception untuk Network
class NetworkException extends FirebaseException {
  const NetworkException() : super('Tidak ada koneksi internet');
}

/// Exception untuk error yang tidak diketahui
class UnknownException extends FirebaseException {
  const UnknownException([String? message]) 
      : super(message ?? 'Terjadi kesalahan');
}

/// Exception untuk Cloud Functions
class CloudFunctionsException extends FirebaseException {
  const CloudFunctionsException(super.message, [super.code]);

  static String getFunctionsMessage(String code, String? message) {
    switch (code) {
      case 'unauthenticated':
        return 'Anda harus login terlebih dahulu';
      case 'not-found':
        return message ?? 'Produk tidak ditemukan';
      case 'invalid-argument':
        return message ?? 'Data tidak valid';
      case 'permission-denied':
        return 'Tidak memiliki izin akses';
      case 'unavailable':
        return 'Layanan tidak tersedia, coba lagi nanti';
      case 'internal':
        return 'Terjadi kesalahan server';
      default:
        return message ?? 'Terjadi kesalahan: $code';
    }
  }
}
