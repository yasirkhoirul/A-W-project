import 'package:a_and_w/core/database/app_database.dart';
import 'package:a_and_w/features/auth/data/datasource/local_auth_datasource.dart';
import 'package:a_and_w/features/auth/data/datasource/remote_auth_datasource.dart';
import 'package:a_and_w/features/auth/data/repository_implementation/auth_repository_impl.dart';
import 'package:a_and_w/features/auth/domain/repository/auth_repository.dart';
import 'package:a_and_w/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:a_and_w/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:a_and_w/features/auth/presentation/bloc/profile_bloc.dart';
import 'package:a_and_w/features/barang/data/datasource/barang_local_datasource.dart';
import 'package:a_and_w/features/barang/data/datasource/barang_remote_datasource.dart';
import 'package:a_and_w/features/barang/data/repository_implementation/barang_repository_impl.dart';
import 'package:a_and_w/features/barang/domain/repository/barang_repository.dart';
import 'package:a_and_w/features/barang/domain/usecase/get_all_barang.dart';
import 'package:a_and_w/features/barang/domain/usecase/get_barang.dart';
import 'package:a_and_w/features/barang/domain/usecase/get_barang_by_kategori.dart';
import 'package:a_and_w/features/barang/domain/usecase/get_keranjang.dart';
import 'package:a_and_w/features/barang/domain/usecase/hapus_barang_keranjang.dart';
import 'package:a_and_w/features/barang/domain/usecase/tambah_barang_keranjang.dart';
import 'package:a_and_w/features/barang/domain/usecase/update_kuantitas_keranjang.dart';
import 'package:a_and_w/features/barang/presentation/cubit/barang_cubit.dart';
import 'package:a_and_w/features/barang/presentation/cubit/detail_barang_cubit.dart';
import 'package:a_and_w/features/barang/presentation/cubit/keranjang_cubit.dart';
import 'package:a_and_w/features/history/data/datasources/history_remote_datasource.dart';
import 'package:a_and_w/features/history/data/history_repository_impl/history_repository_impl.dart';
import 'package:a_and_w/features/history/domain/repositories/history_repository.dart';
import 'package:a_and_w/features/history/domain/usecases/get_history.dart';
import 'package:a_and_w/features/history/presentation/cubit/history_cubit.dart';
import 'package:a_and_w/features/pengantaran/data/datasource/pengantaran_remote_datasource.dart';
import 'package:a_and_w/features/pengantaran/data/repository_implementation/pengantaran_repository_impl.dart';
import 'package:a_and_w/features/pengantaran/domain/repository/pengantaran_repository.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/get_list_distrik.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/get_list_kota.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/get_list_provinsi.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/cost_pengantaran.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/track_pengantaran.dart';
import 'package:a_and_w/features/pengantaran/presentation/bloc/pengantara_check_track_bloc.dart';
import 'package:a_and_w/features/pengantaran/presentation/cubit/alamat_dropdown_cubit.dart';
import 'package:a_and_w/features/pesanan/data/datasource/remote_datasource.dart';
import 'package:a_and_w/features/pesanan/data/repository_implementation/pesanan_repository_impl.dart';
import 'package:a_and_w/features/pesanan/domain/repository/pesanan_repository.dart';
import 'package:a_and_w/features/pesanan/domain/usecase/get_cart.dart';
import 'package:a_and_w/features/pesanan/domain/usecase/submit_pesanan.dart';
import 'package:a_and_w/features/pesanan/presentation/bloc/pesanan_bloc.dart';
import 'package:a_and_w/features/pesanan/presentation/cubit/get_pesanan_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

final locator = GetIt.instance;

Future<void> getitInit() async {
  //localnotification
  locator.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    () => FlutterLocalNotificationsPlugin(),
  );

  //http
  locator.registerLazySingleton<http.Client>(() => http.Client());
  //firebase
  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  locator.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  locator.registerLazySingleton<FirebaseMessaging>(
    () => FirebaseMessaging.instance,
  );
  // Cloud Functions region: us-central1 (default)
  locator.registerLazySingleton<FirebaseFunctions>(
    () => FirebaseFunctions.instance,
  );
  locator.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());
  //secure storage
  locator.registerLazySingleton<FlutterSecureStorage>(
    () => FlutterSecureStorage(),
  );

  //Drift
  locator.registerLazySingleton<AppDatabase>(() => AppDatabase());

  //datasource
  locator.registerLazySingleton<LocalAuthDatasource>(
    () => LocalAuthDatasourceImpl(locator<FirebaseAuth>()),
  );
  locator.registerLazySingleton<RemoteAuthDataSource>(
    () => RemoteAuthDatasourceImpl(
      firebaseAuth: locator(),
      firebaseFirestore: locator(),
      googleSignIn: locator(),
      firebaseMessaging: locator(),
    ),
  );
  locator.registerLazySingleton<PengantaranRemoteDatasource>(
    () => PengantaranRemoteDatasourceImpl(locator()),
  );
  locator.registerLazySingleton<BarangRemoteDatasource>(
    () => BarangRemoteDatasourceImpl(firestore: locator()),
  );
  locator.registerLazySingleton<BarangLocalDatasource>(
    () => BarangLocalDatasourceImpl(db: locator()),
  );
  locator.registerLazySingleton<PesananRemoteDatasource>(
    () => PesananRemoteDatasourceImpl(
      functions: locator(),
      firebaseAuth: locator(),
    ),
  );
  locator.registerLazySingleton<HistoryRemoteDatasource>(
    () => HistoryRemoteDatasourceImpl(firestore: locator(), auth: locator()),
  );

  //repository
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: locator(),
      localAuthDatasource: locator(),
    ),
  );
  locator.registerLazySingleton<PengantaranRepository>(
    () => PengantaranRepositoryImpl(locator()),
  );
  locator.registerLazySingleton<BarangRepository>(
    () => BarangRepositoryImpl(
      remoteDatasource: locator(),
      localDatasource: locator(),
    ),
  );
  locator.registerLazySingleton<PesananRepository>(
    () => PesananRepositoryImpl(remoteDatasource: locator()),
  );
  locator.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(locator()),
  );

  //usecase
  //usecase auth
  locator.registerLazySingleton<SignInWithEmailUseCase>(
    () => SignInWithEmailUseCase(locator()),
  );
  locator.registerLazySingleton<SignInWithGoogleUseCase>(
    () => SignInWithGoogleUseCase(locator()),
  );
  locator.registerLazySingleton<SignUpUseCase>(() => SignUpUseCase(locator()));
  locator.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(locator()),
  );
  locator.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(locator()),
  );
  locator.registerLazySingleton<CheckAuthStatusUseCase>(
    () => CheckAuthStatusUseCase(locator()),
  );
  locator.registerLazySingleton(() => GetProfileUsecase(locator()));
  locator.registerLazySingleton(() => UpdateProfileUsecase(locator()));
  //usecase pengantaran
  locator.registerLazySingleton(() => GetListProvinsi(repository: locator()));
  locator.registerLazySingleton(() => GetListKota(repository: locator()));
  locator.registerLazySingleton(
    () => GetListDistrik(pengantaranRepository: locator()),
  );
  locator.registerLazySingleton(() => CostPengantaran(locator()));
  //usecase barang
  locator.registerLazySingleton(
    () => GetBarangByKategori(repository: locator()),
  );
  locator.registerLazySingleton(() => GetBarang(repository: locator()));
  locator.registerLazySingleton(() => GetAllBarang(repository: locator()));
  //usecase keranjang
  locator.registerLazySingleton(() => GetKeranjang(repository: locator()));
  locator.registerLazySingleton(
    () => TambahBarangKeranjang(repository: locator()),
  );
  locator.registerLazySingleton(
    () => HapusBarangKeranjang(repository: locator()),
  );
  locator.registerLazySingleton(
    () => UpdateKuantitasKeranjang(repository: locator()),
  );
  //usecase pesanan
  locator.registerLazySingleton(() => GetCart(repository: locator()));
  locator.registerLazySingleton(() => SubmitPesanan(locator()));
  //usecase history
  locator.registerLazySingleton(() => GetHistory(locator()));
  locator.registerLazySingleton(() => GetHistoryDetail(locator()));
  //usecase trackpengantantaran
  locator.registerLazySingleton(() => TrackPengantaran(locator()));

  //bloc
  //bloc auth
  locator.registerCachedFactory<DetailBarangCubit>(
    () => DetailBarangCubit(getBarang: locator()),
  );
  locator.registerLazySingleton<ProfileBloc>(
    () => ProfileBloc(
      getProfileUsecase: locator(),
      updateProfileUsecase: locator(),
      getCurrentUserUseCase: locator(),
    ),
  );
  locator.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      signInWithEmailUseCase: locator(),
      signInWithGoogleUseCase: locator(),
      signUpUseCase: locator(),
      signOutUseCase: locator(),
      checkAuthStatusUseCase: locator(),
      authRepository: locator(),
    ),
  );
  //bloc barang
  locator.registerLazySingleton<BarangCubit>(
    () => BarangCubit(getAllBarang: locator(), getBarangByKategori: locator()),
  );
  //cubit keranjang
  locator.registerLazySingleton<KeranjangCubit>(
    () => KeranjangCubit(
      getKeranjang: locator(),
      tambahBarangKeranjang: locator(),
      hapusBarangKeranjang: locator(),
      updateKuantitasKeranjang: locator(),
    ),
  );
  //bloc pengantaran
  locator.registerCachedFactory<PengantaraCheckTrackBloc>(
    () => PengantaraCheckTrackBloc(locator(), locator()),
  );
  //cubit alamat dropdown - factory karena bisa dipakai di banyak page
  locator.registerFactory<AlamatDropdownCubit>(
    () => AlamatDropdownCubit(locator(), locator(), locator()),
  );
  //bloc pesanan - inject multiple usecases (composition pattern)
  locator.registerFactory(
    () => PesananBloc(
      costPengantaran: locator(), // Cross-feature usecase - OK di presentation
      submitPesanan: locator(),
    ),
  );
  locator.registerFactory(() => GetPesananCubit(locator()));

  //bloc history
  locator.registerFactory<HistoryCubit>(
    () => HistoryCubit(getHistory: locator()),
  );
  locator.registerFactory<HistoryDetailCubit>(
    () => HistoryDetailCubit(getHistoryDetail: locator()),
  );
}
