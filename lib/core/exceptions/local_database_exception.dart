/// Exception untuk error database lokal (Drift/SQLite)
class LocalDatabaseException implements Exception {
  final String message;

  const LocalDatabaseException([
    this.message = 'Terjadi kesalahan database lokal',
  ]);

  @override
  String toString() => 'LocalDatabaseException: $message';
}
