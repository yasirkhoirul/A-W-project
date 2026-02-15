import 'package:a_and_w/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:a_and_w/features/pesanan/domain/repository/pesanan_repository.dart';
import 'package:a_and_w/features/pesanan/domain/usecase/submit_pesanan.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/cost_pengantaran.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:a_and_w/features/auth/domain/repository/auth_repository.dart';
import 'package:a_and_w/features/pengantaran/domain/repository/pengantaran_repository.dart';

@GenerateMocks([
  AuthRepository,
  User,
  PengantaranRepository,
  PesananRepository,
  FirebaseFirestore,
  GetProfileUsecase,
  UpdateProfileUsecase,
  GetCurrentUserUseCase,
  SubmitPesanan,
  CostPengantaran,
])
void main() {}
