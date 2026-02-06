import 'package:equatable/equatable.dart';

/// Base class untuk failures
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Failure untuk Authentication
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Failure untuk Firestore
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// Failure untuk Storage
class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

/// Failure untuk Network
class NetworkFailure extends Failure {
  const NetworkFailure() : super('Tidak ada koneksi internet');
}

/// Failure untuk HTTP API errors
class HttpApiFailure extends Failure {
  const HttpApiFailure(super.message);
}

/// Failure untuk Unknown errors
class UnknownFailure extends Failure {
  const UnknownFailure([String? message]) 
      : super(message ?? 'Terjadi kesalahan');
}
