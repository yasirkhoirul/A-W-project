import 'package:a_and_w/features/auth/domain/repository/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repository;

  const CheckAuthStatusUseCase(this.repository);

  Stream<bool> call() {
    return repository.checkStatusAuth();
  }
}
