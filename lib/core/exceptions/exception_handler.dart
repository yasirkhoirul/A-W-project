import 'package:a_and_w/core/exceptions/http_api_exception.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:a_and_w/core/exceptions/firebase_exception.dart';
import 'package:a_and_w/core/exceptions/failure.dart';

/// Helper untuk convert exception ke Failure
class ExceptionHandler {
  /// Convert exception ke Failure
  static Failure handle(dynamic error) {
    // Firebase Auth Exception
    if (error is firebase_auth.FirebaseAuthException) {
      return AuthFailure(AuthException.fromFirebase(error).message);
    }

    // Firebase Exception (Firestore/Storage)
    if (error is firebase_auth.FirebaseException) {
      if (error.plugin == 'cloud_firestore') {
        return DatabaseFailure(DatabaseException.fromFirebase(error).message);
      }
      if (error.plugin == 'firebase_storage') {
        return StorageFailure(StorageException.fromFirebase(error).message);
      }
    }

    // HTTP API exception
    if (error is HttpException) {
      if (error is HttpNetworkException) {
        return const NetworkFailure();
      }
      if (error is HttpApiException && error.message.contains('Server')) {
        return DatabaseFailure(error.message);
      }
      return HttpApiFailure(error.message);
    }

    // Custom Exceptions
    if (error is AuthException) {
      return AuthFailure(error.message);
    }
    if (error is DatabaseException) {
      return DatabaseFailure(error.message);
    }
    if (error is StorageException) {
      return StorageFailure(error.message);
    }
    if (error is NetworkException) {
      return const NetworkFailure();
    }

    // Network errors
    if (error.toString().contains('SocketException') ||
        error.toString().contains('network')) {
      return const NetworkFailure();
    }

    // Default
    return UnknownFailure(error.toString());
  }
}
