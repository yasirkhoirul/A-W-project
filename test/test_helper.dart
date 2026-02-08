import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:a_and_w/features/auth/domain/repository/auth_repository.dart';
import 'package:a_and_w/features/pengantaran/domain/repository/pengantaran_repository.dart';

@GenerateMocks([AuthRepository, User, PengantaranRepository])
void main() {}
